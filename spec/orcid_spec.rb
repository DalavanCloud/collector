# encoding: utf-8
require_relative "./spec_helper"

describe "Utility function to parse ORCIDs" do
  before(:all) do
    @utility = Collector::AgentUtility
  end

  it "should recognize a valid ORCID, all nums" do
    input = "0000-0002-1825-0097"
    expect(@utility.is_orcid?(input)).to be true
  end

  it "should recognize a valid ORCID, X checksum" do
    input = "0000-0002-1825-009X"
    expect(@utility.is_orcid?(input)).to be true
  end

  it "should not recognize an ivalid ORCID" do
    input = "0000-0002-1825-009A"
    expect(@utility.is_orcid?(input)).to be false
  end
end