require "rails_helper"

RSpec.describe RailsComponents::Design::PreviewController, type: :controller do
  routes { RailsComponents::Engine.routes }

  describe "GET #index" do
    context "when preview is enabled" do
      before do
        RailsComponents.configuration.enable_preview = true
      end

      it "returns a successful response" do
        get :index
        expect(response).to be_successful
        expect(response.status).to eq(200)
      end

      it "renders html content" do
        get :index
        expect(response.content_type).to include("text/html")
      end
    end

    context "when preview is disabled" do
      before do
        RailsComponents.configuration.enable_preview = false
      end

      after do
        # Reset to default
        RailsComponents.configuration.enable_preview = true
      end

      it "raises a routing error" do
        expect {
          get :index
        }.to raise_error(ActionController::RoutingError, "Preview is not enabled")
      end
    end
  end
end
