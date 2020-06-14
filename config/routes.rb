Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  namespace :sdk do
    versions = {
        v1: %w[0.0]
    }
    versions.to_a.reverse.each do |major, minors|
      minors.sort.reverse.each do |minor|
        scope path: "(/#{major}.#{minor})", module: major do
          get 'embed', to: 'events#embed'
          get 'fire', to: 'events#fire'
          get 'hit', to: 'events#hit'
          resources :projects, only: :show
        end
      end
    end
  end

  resources :organizations, param: :slug do
    # resources :users, only: [:index], controller: :organization_users do
    #   resources :organization_users, only: %i[create destroy], on: :member, shallow: true
    # end
    resources :organization_users, only: %i[index create destroy], as: :users, shallow: true do
      post 'invite', on: :collection
    end
    resources :projects, shallow: true, except: :edit

    scope :settings do
      resources :projects, only: [:update], controller: 'projects/settings', as: :project_setting do
        member do
          root 'projects/settings#general'
        end
      end
    end

    resources :notifications
    resources :hits, except: %i[new create edit update destroy]
  end

  root 'organizations#index'
end
