FactoryGirl.define do
  factory :content do
    data 'Data'
    data_type 'Data type'
    association(:target)
  end
end