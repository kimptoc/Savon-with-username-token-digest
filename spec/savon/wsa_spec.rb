require "spec_helper"

describe Savon::WSA do
  let(:wsa) { Savon::WSA.new }

  it "should contain the namespace for WS Addressing" do
    Savon::WSA::WSANamespace.should ==
      "http://schemas.xmlsoap.org/ws/2004/08/addressing"
  end

  describe "#action" do
    it "should set the action" do
      wsa.action = "action"
      wsa.action.should == "action"
    end
  end

  describe "#reply to" do
    it "should set the reply_to" do
      wsa.reply_to = "reply to"
      wsa.reply_to.should == "reply to"
    end
  end

  describe "#message_id" do
    it "should set the message_id" do
      wsa.message_id = "message id"
      wsa.message_id.should == "message id"
    end
  end

  describe "#to" do
    it "should set the to" do
      wsa.to = "to"
      wsa.to.should == "to"
    end
  end

  #todo - dont think this is needed
#  describe '#body_attributes' do
#    context 'by default' do
#      it "should return an empty hash" do
#        wsa.body_attributes.should == {}
#      end
#    end
#
#    context 'with a signature' do
#      let(:signature) { Savon::WSSE::Signature.new }
#      before { wsa.sign_with = signature }
#
#      it "should return the signatures body_attributes" do
#        wsa.body_attributes.should == signature.body_attributes
#      end
#    end
#  end
  
  describe "#to_xml" do

    context "with no address info" do
      it "should return an empty String" do
        wsa.to_xml.should == ""
      end
    end

    context "with only a reply_to" do
      before { wsa.reply_to = "reply to" }

      it "should return an empty String" do
        wsa.to_xml.should == ""
      end
    end

    context "with only a action" do
      before { wsa.action = "action" }

      it "should return an empty String" do
        wsa.to_xml.should == ""
      end
    end

    context "with only a message id" do
      before { wsa.message_id = "message id" }

      it "should return an empty String" do
        wsa.to_xml.should == ""
      end
    end

    context "with only a to" do
      before { wsa.to = "to" }

      it "should return an empty String" do
        wsa.to_xml.should == ""
      end
    end

    context "with 3 of 4 bits" do
      before do
        wsa.action = "action"
        wsa.message_id = "message id"
        wsa.to = "to"
      end

      it "should return an empty String" do
        wsa.to_xml.should == ""
      end
    end

    context "with full details" do
      before do
        wsa.action = "action"
        wsa.message_id = "message id"
        wsa.reply_to = "reply to"
        wsa.to = "to"
      end

      it "should contain a wsa:ReplyTo tag" do
        wsa.to_xml.should include("<wsa:ReplyTo")
      end

      it "should contain a wsa:Address tag" do
        wsa.to_xml.should include("<wsa:Address")
      end

      it "should contain a wsa:MessageID tag" do
        wsa.to_xml.should include("<wsa:MessageID")
      end

      it "should contain a wsa:To tag" do
        wsa.to_xml.should include("<wsa:To")
      end

      it "should contain a Action wsu:Id attribute" do
        wsa.to_xml.should include('<wsa:Action wsu:Id="Action-1"')
      end

      #this is probably quite fragile - relies on tags being added in this order
      it "should contain a MessageID wsu:Id attribute" do
        wsa.to_xml.should include('<wsa:MessageID wsu:Id="MessageID-2"')
      end

      it "should contain a ReplyTo wsu:Id attribute" do
        wsa.to_xml.should include('<wsa:ReplyTo wsu:Id="ReplyTo-3"')
      end

      it "should contain a To wsu:Id attribute" do
        wsa.to_xml.should include('<wsa:To wsu:Id="To-4"')
      end

      it "should increment the wsu:Id attribute count" do
        wsa.to_xml.should include('<wsa:Action wsu:Id="Action-1"')
        wsa.to_xml.should include('<wsa:Action wsu:Id="Action-5"')
      end

      it "should contain the Reply To" do
        wsa.to_xml.should include("reply to")
      end

      it "should contain the Message ID" do
        wsa.to_xml.should include("message id")
      end

      it "should contain the Action" do
        wsa.to_xml.should include("action")
      end

      it "should contain the To" do
        wsa.to_xml.should include("to")
      end

    end
  end

end
