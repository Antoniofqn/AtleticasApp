# spec/integration/clubs_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/clubs', type: :request do

  path '/api/v1/clubs' do

    get('list clubs') do
      tags 'Clubs'
      produces 'application/json'
      parameter name: :university_hashid, in: :query, type: :string, required: false, description: 'University Hash ID'

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string, enum: ['club'] },
                       attributes: {
                         type: :object,
                         properties: {
                           name: { type: :string },
                           description: { type: :string, nullable: true },
                           year_of_foundation: { type: :integer, nullable: true },
                           logo_url: { type: :string, nullable: true },
                           slug: { type: :string },
                           university: {
                             type: :object,
                             properties: {
                               name: { type: :string },
                               slug: { type: :string },
                               hashid: { type: :string }
                             }
                           }
                         }
                       }
                     }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path '/api/v1/clubs/{id}' do

    get('show club') do
      tags 'Clubs'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :string, description: 'Club ID'

      response(200, 'successful') do
        let!(:club) { create(:club) }
        let(:id) { club.hashid }

        schema type: :object,
               properties: {
                 data: {
                   type: :object,
                   properties: {
                     id: { type: :string },
                     type: { type: :string, enum: ['club'] },
                     attributes: {
                       type: :object,
                       properties: {
                         name: { type: :string },
                         description: { type: :string, nullable: true },
                         year_of_foundation: { type: :integer, nullable: true },
                         logo_url: { type: :string, nullable: true },
                         slug: { type: :string },
                         university: {
                           type: :object,
                           properties: {
                             name: { type: :string },
                             slug: { type: :string },
                             hashid: { type: :string }
                           }
                         }
                       }
                     }
                   }
                 }
               }

        run_test!
      end
    end

    patch('update club') do
      tags 'Clubs'
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :string, description: 'Club ID'
      parameter name: 'access-token', in: :header, type: :string
      parameter name: 'client', in: :header, type: :string
      parameter name: 'uid', in: :header, type: :string
      parameter name: :club, in: :body, schema: {
        type: :object,
        properties: {
          club: {
            type: :object,
            properties: {
              name: { type: :string },
              description: { type: :string },
              year_of_foundation: { type: :integer, nullable: true },
              logo_url: { type: :string, nullable: true },
              slug: { type: :string },
              university: {
                type: :object,
                properties: {
                  name: { type: :string },
                  slug: { type: :string },
                  hashid: { type: :string }
                }
              }
            }
          }
        }
      }

      let!(:user) { create(:user, password: 'password', password_confirmation: 'password') }  # Assuming you have a user factory
      let!(:club) { create(:club) }  # Create a club associated with the user
      let!(:club_user) { create(:club_user, user: user, club: club) }
      let(:id) { club.hashid }
      let(:club_params) { { club: { name: 'Updated Club Name', description: 'Updated Description' } } }
      let(:tokens) { user.create_new_auth_token.slice('client', 'access-token', 'uid') }

      response(200, 'successful') do
        let(:client) { tokens['client'] }
        let('access-token') { tokens['access-token'] }
        let(:uid) { tokens['uid'] }
        run_test! do |request|
          request.body = club_params.to_json
        end
      end
    end
  end
end
