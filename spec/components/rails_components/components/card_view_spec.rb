require "rails_helper"

RSpec.describe "Card helper", type: :helper do
  before do
    helper.extend(RailsComponents::ComponentHelper)
  end

  it "renders basic card correctly" do
    output = helper.card do
      "Test content"
    end

    expect(output).to include('class="card bg-base-100"')
    expect(output).to include("Test content")
  end

  it "renders with border option" do
    output = helper.card(bordered: true) do
      "Bordered content"
    end

    expect(output).to include('class="card card-border bg-base-100"')
    expect(output).to include("Bordered content")
  end

  it "renders with shadow option" do
    output = helper.card(shadow: "lg") do
      "Shadow content"
    end

    expect(output).to include('class="card shadow-lg bg-base-100"')
    expect(output).to include("Shadow content")
  end

  it "renders with both options" do
    output = helper.card(bordered: true, shadow: "xl") do
      "Combined content"
    end

    expect(output).to include('class="card card-border shadow-xl bg-base-100"')
    expect(output).to include("Combined content")
  end

  it "renders with custom html options" do
    output = helper.card(html_options: { id: "custom-card", class: "bg-primary" }) do
      "Custom content"
    end

    expect(output).to include('id="custom-card"')
    expect(output).to include('class="card bg-base-100 bg-primary"')
    expect(output).to include("Custom content")
  end

  it "renders with color option" do
    output = helper.card(color: "bg-secondary") do
      "Colored content"
    end

    expect(output).to include('class="card bg-secondary"')
    expect(output).to include("Colored content")
  end
end
