require 'rails_helper'

RSpec.describe CompaignsController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}
  let(:compaign) {FactoryGirl.create(:compaign, user: user)}
  let(:compaign1) {FactoryGirl.create(:compaign)}
  #"user:" -> "belongs_to: user"; "user" -> the result function returns
  #is equivalent to
  # def user
  #   @user ||= FactoryGirl.create(:user)
  # end

  describe '#new' do
    context 'with no user signed in' do
      it 'redirects the user to the home page' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end
    context 'with user signed in' do
      # add a way to authenticate the user
      # you can use `before` method which takes a block of code. This block of
      # code will be executed before every example. Remember that every example
      # is independent from the other which mean the block will be executed
      # before each one of them gets executed.

      # before do
      #   user = FactoryGirl.create(:user)
      #   # RSpec Rails gives us access to an object called `request` which we
      #   # can use to set things like the `session` when we're mimicking a
      #   # controller request.
      #   request.session[:user_id] = user.id
      # end

      before { request.session[:user_id] = user.id }
      it 'renders the new template' do
        # GIVEN: Nothing (just the created Rails controller)

        # WHEN: We make a GET request to the `new` action in CampaignsController
        # RSpec Rails makes it super easy to mimick the `GET` request by doing:
        get :new

        # THEN: We render the `new` template
        # RSpec Rails gives us access to the controller's `request` and `response`
        # objects to make it easy to manipulate or match. We usually manipulate
        # the request (to mimick user signed in for instance) and we usually match
        # the response object to test outcome.
        # render_template is RSpec Rails matcher
        expect(response).to render_template(:new)
      end

      it 'assigns a new Compaign instance variable' do
      # GIVEN: nothing (just the Rails controller)

      # WHEN: we make a GET request to the `new action`
      get :new

      # THEN: we assign a new `Campaign` instance variable
      # assigns: is a method that will look for instance variables defined in
      #          your controller's action
      # be_a_new: is an RSpec Rails matcher that will ensure that what you're
      #           matching is a new instance of the class you pass in which is
      #           `Campaign` in this case
      # @campaign instance variable should be a new instance of the Campaign
      # class
      expect(assigns(:compaign)).to be_a_new(Compaign)
    end
    end
  end

  describe '#create' do

    context 'with no signed in user' do
      it 'redirects to the home page' do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with signed in user' do
      before {request.session[:user_id] = user.id}
      context 'with valid attributes' do
        # you can define methods within `describes` and `contexts`. Keep in mind
        # that those methods will only be accessible for examples that are within
        # those `describes` and `contexts` or nesed `describes` or `contexts`
        def valid_request
          post :create, params: {compaign: FactoryGirl.attributes_for(:compaign)}
        end
        it 'creates a new campaign in the database' do
          count_before = Compaign.count
          # make the request
          valid_request
          count_after = Compaign.count
          expect(count_after).to eq(count_before + 1)
        end
        it 'redirects to the compaign show page' do
          # GIVEN: nothing (just the Rails controller)

          # WHEN: we make a `POST` request with valid params
          valid_request

          # THEN: we gets redirected to the campaign's show page
          expect(response).to redirect_to(compaign_path(Compaign.last))
        end
        it 'associates the created compaign with the signed in user' do
          #GIVEN: user is signed in (done in the before block)
          #WHEN: we make a 'POST' request to the compaign controller create
          valid_request
          #THEN: the created compaign is associated with the signed in user
          expect(Compaign.last.user).to eq(user)
        end
        it 'sets a flash message' do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context 'with invalid attributes' do
      def invalid_request
        post :create, params: {compaign: FactoryGirl.attributes_for(:compaign, title: nil)}
      end

      it 'desont\'t create  record in the database' do
        count_before = Compaign.count
        invalid_request
        count_after = Compaign.count
        expect(count_before).to eq(count_after)
      end


      it 'renders the new template' do
        invalid_request
        expect(response).to render_template(:new)
      end
    end
    end
  end

  describe '#edit' do
    context 'with no user sign in' do
      it 'redirects to the home page' do
        get :edit, params:{ id: compaign.id}
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with user signed in' do
      before {request.session[:user_id] = user.id}
      context 'with owner of compaign signed in' do
        it 'render the edit page' do
          get :edit, params: {id: compaign.id}
          expect(response).to render_template(:edit)
        end
        it 'sets an instance variable to the compaign whose id was passed' do
          get :edit, params: {id: compaign.id}
          expect(assigns(:compaign)).to eq(compaign)
          # assigns(:campaign) -> instance variable set in the edit action
          # campaign           -> is the campagin object whose id we passed
          #                        with the request to the `edit` action
        end
      end
      context 'with non-owner of compaign signed in' do
        it 'redirects to the home page' do
          get :edit, params: {id: compaign1.id }
          expect(response).to redirect_to(root_path)
        end
      end
    end
  end

  describe '#destroy' do
    context 'with no signd in user' do

    end
    context 'with signed in user' do
      before {request.session[:user_id] = user.id}
      context 'with signed in user is owner of compaign' do
        it 'removes the compaign record form the database' do
          compaign # we call campaign here to force creating the campaign before
                   # making the `delete :destroy` call
          byebug
          count_before = Compaign.count
          delete :destroy, params: { id: compaign.id }
          count_after  = Compaign.count
          expect(count_after).to eq(count_before - 1)
        end
      end

    end
  end
end
