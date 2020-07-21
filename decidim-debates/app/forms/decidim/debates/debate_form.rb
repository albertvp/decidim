# frozen_string_literal: true

module Decidim
  module Debates
    # This class holds a Form to create/update debates from Decidim's public views.
    class DebateForm < Decidim::Form
      include TranslatableAttributes

      attribute :title, String
      attribute :description, String
      attribute :category_id, Integer
      attribute :decidim_scope_id, Integer
      attribute :user_group_id, Integer

      validates :title, presence: true
      validates :description, presence: true

      validates :category, presence: true, if: ->(form) { form.category_id.present? }
      validates :scope, presence: true, if: ->(form) { form.decidim_scope_id.present? }
      validates :decidim_scope_id, scope_belongs_to_component: true, if: ->(form) { form.decidim_scope_id.present? }

      def category
        @category ||= current_component.categories.find_by(id: category_id)
      end

      # Finds the Scope from the given decidim_scope_id, uses component scope if missing.
      #
      # Returns a Decidim::Scope
      def scope
        @scope ||= @decidim_scope_id ? current_component.scopes.find_by(id: @decidim_scope_id) : current_component.scope
      end

      # Scope identifier
      #
      # Returns the scope identifier related to the debate
      def decidim_scope_id
        @decidim_scope_id || scope&.id
      end
    end
  end
end
