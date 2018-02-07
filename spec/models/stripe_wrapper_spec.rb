require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe '.create', :vcr do
      it "makes successful charge" do
        Stripe.api_key = ENV["stripe_api_key"]

        token = Stripe::Token.create(
          :card => {
            :number => "4242424242424242",
            :exp_month => 1,
            :exp_year => 2019,
            :cvc => "314"
          },
        )

        response = StripeWrapper::Charge.create(
          amount: 999,
          description: "Test",
          source: token
        )

        expect(response.amount).to eq(999)
        expect(response.description).to eq("Test")
      end
    end
  end
end