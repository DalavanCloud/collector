class Barcode < ActiveRecord::Base

  def self.populate_barcodes
    barcodes = Agent.where("id = canonical_id AND processed_barcodes IS NULL").where.not(given: [nil,''])

    Parallel.map(barcodes.find_each, progress: "Barcodes") do |agent|
      barcodes = []
      tmp_file = "/tmp/%s.xml" % agent.id

      params = {
        :researchers => agent.fullname,
        :format => 'xml'
      }

      url = URI(Sinatra::Application.settings.bold_api_url)

      Net::HTTP.start(url.host.downcase) do |http|
        resp = http.get([url.path, URI.encode_www_form(params)].join("?"))
        open(tmp_file, "wb") do |file|
          file.write(resp.body)
        end
      end

      file_size = File.stat(tmp_file).size

      if file_size > 0 && file_size < 20000000
        xml = Nokogiri::XML.parse(File.open(tmp_file))
        xml.xpath("//record").each do |record|
          processid = nil
          bin_uri = nil
          catalognum = nil
          record.children.each do |element|
            processid = element.text if element.name == 'processid'
            bin_uri = element.text if element.name == 'bin_uri'
            if element.name == 'specimen_identifiers'
              element.children.each do |sid|
                catalognum = sid.text if sid.name == 'catalognum'
              end
            end
          end
          barcodes << { processid: processid, bin_uri: bin_uri, catalognum: catalognum } if processid
        end
      end

      File.delete(tmp_file)

      Barcode.transaction do
        barcodes.each do |b|
          begin
            barcode = Barcode.create_with(bin_uri: b[:bin_uri], catalognum: b[:catalognum]).find_or_create_by(processid: b[:processid])
            AgentBarcode.find_or_create_by(agent_id: agent.id, barcode_id: barcode.id)
          rescue ActiveRecord::RecordNotUnique
            retry
          end
        end
        agent.processed_barcodes = true
        agent.save
      end

    end

  end

end