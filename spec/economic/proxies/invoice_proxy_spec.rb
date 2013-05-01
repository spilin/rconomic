require './spec/spec_helper'

describe Economic::InvoiceProxy do

  let(:session) { make_session }
  subject { Economic::InvoiceProxy.new(session) }

  describe ".new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new Invoice" do
      subject.build.should be_instance_of(Economic::Invoice)
    end

    it "assigns the session to the Invoice" do
      subject.build.session.should === session
    end

    it "should not build a partial Invoice" do
      subject.build.should_not be_partial
    end
  end

  describe ".find" do
    before :each do
      expect_api_request(:invoice_get_data, {"entityHandle"=>{"Number"=>42}}, :success)
    end

    it "gets invoice data from API" do
      subject.find(42)
    end

    it "returns Invoice object" do
      subject.find(42).should be_instance_of(Economic::Invoice)
    end
  end  

  describe ".find_by_date_interval" do
    let(:from) { Time.now - 60 }
    let(:unto) { Time.now }

    it "should be able to return a single current invoice" do
      expect_api_request(:invoice_find_by_date_interval, {'first' => from.iso8601, 'last' => unto.iso8601, :order! => ['first', 'last']}, :single)
      expect_api_request(:invoice_get_data_array, {"entityHandles"=>{"InvoiceHandle"=>[{"Number"=>1}]}}, :single)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 1
      results.first.should be_instance_of(Economic::Invoice)
    end

    it "should be able to return multiple invoices" do
      expect_api_request(:invoice_find_by_date_interval, {'first' => from.iso8601, 'last' => unto.iso8601, :order! => ['first', 'last']}, :many)
      expect_api_request(:invoice_get_data_array, {"entityHandles"=>{"InvoiceHandle"=>[{"Number"=>1}, {"Number"=>2}]}}, :multiple)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 2
      results.first.should be_instance_of(Economic::Invoice)
    end

    it "should be able to return nothing" do
      expect_api_request(:invoice_find_by_date_interval, {'first' => from.iso8601, 'last' => unto.iso8601, :order! => ['first', 'last']}, :none)
      results = subject.find_by_date_interval(from, unto)
      results.size.should == 0
    end

  end
end
