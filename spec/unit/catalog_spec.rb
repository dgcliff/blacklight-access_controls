require 'spec_helper'

describe Blacklight::AccessControls::Catalog do
  let(:controller) { CatalogController.new }

  describe '#enforce_show_permissions' do
    subject { controller.send(:enforce_show_permissions) }
    let(:params) {{ id: doc.id }}

    before do
      allow(controller).to receive(:current_user).and_return(user)
      allow(controller).to receive(:params).and_return(params)
    end

    context 'when user is not logged in' do
      let(:doc) { create_solr_doc(id: '123') }
      let(:user) { User.new }

      it 'denies access' do
        expect { subject }.to raise_error(Blacklight::AccessControls::AccessDenied)
      end
    end

    context 'when user has access' do
      let(:doc) { create_solr_doc(id: '123', read_access_person_ssim: user.email) }
      let(:user) { build(:user) }

      it 'allows access' do
        expect { subject }.to_not raise_error
      end
    end
  end

end