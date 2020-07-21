# frozen_string_literal: true

require "spec_helper"

describe Decidim::Debates::DebateForm do
  subject { described_class.from_params(attributes).with_context(context) }

  let(:organization) { create(:organization) }
  let(:context) do
    {
      current_organization: organization,
      current_component: current_component
    }
  end
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:current_component) { create :component, participatory_space: participatory_process }
  let(:title) { "My title" }
  let(:description) { "My description" }
  let(:parent_scope) { create(:scope, organization: organization) }
  let(:scope) { create(:subscope, parent: parent_scope) }
  let(:scope_id) { scope.id }
  let(:category) { create :category, participatory_space: participatory_process }
  let(:category_id) { category.id }
  let(:attributes) do
    {
      decidim_scope_id: scope_id,
      category_id: category_id,
      title: title,
      description: description
    }
  end

  describe "scope" do
    let(:form) { subject }

    it_behaves_like "a scopable resource"
  end

  it { is_expected.to be_valid }

  describe "when title is missing" do
    let(:title) { nil }

    it { is_expected.not_to be_valid }
  end

  describe "when description is missing" do
    let(:description) { nil }

    it { is_expected.not_to be_valid }
  end

  describe "when the category does not exist" do
    let(:category_id) { category.id + 10 }

    it { is_expected.not_to be_valid }
  end
end
