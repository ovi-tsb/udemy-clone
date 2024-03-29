class Enrollment < ApplicationRecord
  belongs_to :course, counter_cache: true
  ######## just For. reset the counters in rails console 
  # Course.find_each { |course| Course.reset_counters(course.id,  :enrollments) }
  

  belongs_to :user, counter_cache: true
  ######## just For. reset the counters in rails console 
  # User.find_each { |user| User.reset_counters(user.id,  :enrollments) }

  validates :user, :course, presence: true

  validates :rating, presence: { if: :review? }
  validates :review, presence: { if: :rating? }

  validates_uniqueness_of :user_id, scope: :course_id  #user cant be subscribed to the same course twice
  validates_uniqueness_of :course_id, scope: :user_id  #user cant be subscribed to the same course twice

  validate :cant_subscribe_to_own_course  #user can't create a subscription if course.user == current_user.id

  scope :pending_review, -> { where(rating: [0, nil, ""], review: [0, nil, ""]) }
  scope :reviewed, -> { where.not(review: [0, nil, ""]) }
  scope :latest_good_reviews, -> { order(rating: :desc, created_at: :desc).limit(3) }

  extend FriendlyId
  friendly_id :to_s, use: :slugged

  def to_s
    user.to_s + " " + course.to_s
  end

  def self.ransackable_attributes(auth_object = nil)
    ["review", "rating", "price", "created_at", "updated_at", "rating"]
  end
  def self.ransackable_associations(auth_object = nil)
    ["user", "course"]
  end

  after_save do 
    unless rating.nil? || rating.zero?
      course.update_rating
    end
  end

  after_destroy do 
    course.update_rating
  end

  protected
  def cant_subscribe_to_own_course
    if self.new_record?
      if self.user_id.present?
        if self.user_id == course.user_id
          errors.add(:base, "You can not subscribe to your own course")
        end
      end
    end
  end
end
