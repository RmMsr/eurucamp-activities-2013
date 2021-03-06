require 'spec_helper'

describe Authentication do
  subject { Authentication.new }

  specify { expect { FactoryGirl.create(:activity).dup.save! }.to raise_exception(ActiveRecord::RecordInvalid) }

  it { should     accept_values_for(:user_id, 10) }
  it do
    pending "Currently Removed"
    # should_not accept_values_for(:user_id, nil, "") }
  end

  it { should     accept_values_for(:provider, "github", "twitter") }
  it do
    pending "Currently Removed"
    # should_not accept_values_for(:provider, nil, "") }
  end

  it { should     accept_values_for(:uid, "asd123dasd", "x") }
  it do
    pending "Currently Removed"
    # should_not accept_values_for(:uid, nil, "") }
  end
end
