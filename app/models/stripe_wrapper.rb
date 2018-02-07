module StripeWrapper
  class Charge
    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "cad",
          :description => options[:description],
          :source => options[:source],
        )
      rescue Stripe::CardError => e
        response = e
      end
      response
    end
  end
end