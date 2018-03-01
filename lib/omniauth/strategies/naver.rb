require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Naver < OmniAuth::Strategies::OAuth2
      option :name, 'naver'

      option :client_options, {
        :site => 'https://nid.naver.com',
        :authorize_url => 'https://nid.naver.com/oauth2.0/authorize',
        :token_url => 'https://nid.naver.com/oauth2.0/token',
      }

      uid { raw_properties['id'].to_s }

      info do
        {
          'name' => raw_properties['name'],
          'email' => raw_properties['email'],
          'gender' => gender,
          'image' => image,
        }
      end

      extra do
        {:raw_info => raw_info}
      end

      private

      def gender
        if raw_properties['gener'].nil?
          return nil
        end

        return 'male' if raw_properties['gender'].include? 'M'
        return 'female' if raw_properties['gender'].include? 'F'
      end

      def image
        return raw_properties['profile_image'].sub('?type=s80', '') unless raw_properties['profile_image'].include? 'nodata_33x33.gif'
      end

      def raw_info
        @raw_info ||= access_token.get('https://apis.naver.com/nidlogin/nid/getUserProfile.json').parsed
      end

      def raw_properties
        @raw_properties ||= raw_info['data']['response']
      end
    end
  end
end

OmniAuth.config.add_camelization 'naver', 'Naver'
