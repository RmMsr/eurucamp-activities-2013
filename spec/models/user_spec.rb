require 'spec_helper'

describe User do

  describe "#connected_with_twitter?" do
    subject { user.connected_with_twitter? }
    let(:user) { User.new }

    context  "not connected with Twitter account" do
      before do
        user.should_receive(:provider_connected?).with("twitter").and_return(false)
      end

      it { should == false}
    end

    context "connected with Twitter account" do
      before do
        user.should_receive(:provider_connected?).with("twitter").and_return(true)
      end

      it { should == true }
    end

  end

  describe "#connected_with_github?" do
    subject { user.connected_with_github? }
    let(:user) { User.new }

    context  "not connected with Github account" do
      before do
        user.should_receive(:provider_connected?).with("github").and_return(false)
      end

      it { should == false}
    end

    context "connected with Github account" do
      before do
        user.should_receive(:provider_connected?).with("github").and_return(true)
      end

      it { should == true }
    end
  end

  describe "#apply_provider_handle" do
    subject { user.apply_provider_handle(params) }
    let(:user) { User.new }

    context "no data provided" do
      let(:params) { {} }

      it { should == user }
    end

    context "data provided" do
      let(:params) { { "uid" => "123ASD", "provider" => "github", "info" => {"nickname" => "johnny"} } }

      specify { expect{subject}.to change(user, :github_handle).to("johnny") }

      it { should == user }
    end

  end

  describe "#no_oauth_connected?" do
    subject { user.no_oauth_connected? }
    let(:user) { FactoryGirl.create(:user) }

    context "account connected" do
      context "password set" do
        it { should == true }
      end
    end

    context "no account connected" do
      context "password set" do
        it { should == true }
      end

      context "password not set" do
        let(:user) { User.new  }
        it { should == false }
      end
    end
  end

  describe "#password_required?" do
    subject { user.password_required? }
    let(:user) { FactoryGirl.create(:user) }

    context "no account connected" do
      it { should == true }
    end

    context "account connected" do
      let(:authentications) { [mock(:authentication)] }

      before do
        user.should_receive(:authentications).and_return(authentications)
      end

      it { should == false }
    end

  end

  describe "#update_without_password" do
    subject { user.update_without_password(params) }
    let(:user) { FactoryGirl.create(:user) }

    context "no password provided" do
      let(:params) { {name: "Zbigniew" } }

      specify { expect { subject }.to change(user, :name)  }

      specify { expect { subject }.to_not change(user, :encrypted_password)  }
    end

    context "password" do
      let(:params) { {name: "Zbigniew", password: "qweqwe123123", password_confirmation: "qweqweqwe123123" } }

      specify { expect { subject }.to change(user, :name)  }

      specify { expect { subject }.to change(user, :encrypted_password)  }
    end
  end


  describe "#apply_omniauth" do
    subject { user.apply_omniauth(params) }
    let(:user) { FactoryGirl.create(:user) }

    context "no data provided" do
      let(:params) { {} }

      it { should be_a_kind_of(Authentication) }
      its(:user) { should == user }
      it { should be_invalid }
    end

    context "data provided" do
      context "with info" do
        let(:params) { { 'info' => {"email" => "ala@ala.com"} } }

        specify { expect{subject}.to change(user, :email).to("ala@ala.com") }

        it { should be_a_kind_of(Authentication) }
        its(:user) { should == user }
      end

      context "without info" do
        let(:params) { { "uid" => "123ASD", "provider" => "github" } }

        specify { expect{subject}.to_not change(user, :email) }

        it { should be_a_kind_of(Authentication) }
        its(:user) { should == user }
      end
    end
  end

  describe "validations" do

    subject { User.new }

    it { should     accept_values_for(:email, "xx@xx.com" ) }
    it { should_not accept_values_for(:email, "", nil, " x @ x.com", "123", "login@server." ) }

    it { should     accept_values_for(:password, "qweqweqwe" ) }
    it { should_not accept_values_for(:password, "qweqwe", nil, "") }

    it { should     accept_values_for(:name, nil, "", "Florian Gęga") }

  end

end
