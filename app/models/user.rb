class User < ActiveRecord::Base
    has_many :comments
    has_many :likes
    has_many :posts
end