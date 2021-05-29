# frozen_string_literal: true

require 'rails_helper'

describe 'ResultPermissions' do
  include Canaid::Helpers::PermissionsHelper

  let(:user) { create :user, current_team_id: team.id }
  let(:team) { create :team }
  let(:result) { create :result, user: user, my_module: my_module }
  let(:my_module) { create :my_module, experiment: experiment }
  let(:experiment) { create :experiment, user: user }
  let(:normal_user_role) { create :normal_user_role }

  before do
    create :user_project, user: user, project: experiment.project
    create :user_assignment,
           assignable: experiment.project,
           user: user,
           user_role: normal_user_role,
           assigned_by: user
  end

  describe 'can_read_result?' do
    it 'should be true for active result' do
      expect(can_read_result?(user, result)).to be_truthy
    end

    it 'should be true for archived result' do
      result.archive!(user)

      expect(can_read_result?(user, result)).to be_truthy
    end

    it 'should be true for archived experiment' do
      experiment.update(archived_on: Time.zone.now, archived_by: user)

      expect(can_read_result?(user, result)).to be_truthy
    end
  end

  describe 'can_manage_result?' do
    it 'should be true for active result' do
      expect(can_manage_result?(user, result)).to be_truthy
    end

    it 'should be false for archived result' do
      result.archive!(user)

      expect(can_manage_result?(user, result)).to be_falsey
    end

    it 'should be false for archived experiment' do
      experiment.update(archived_on: Time.zone.now, archived_by: user, archived: true)

      expect(can_manage_result?(user, result)).to be_falsey
    end
  end
end
