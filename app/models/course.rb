class Course < ApplicationRecord
	validates :title, :short_description, :language, :price, :level,  presence: true
	validates :description, presence: true, length: { :minimum => 5 }
  validates :title, uniqueness: true

	belongs_to :user, counter_cache: true
  ######## just For. reset the counters in rails console 
  # User.find_each { |user| User.reset_counters(user.id,  :courses) }
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error
  has_many :user_lessons, through: :lessons
  

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }


	
  def to_s
    title
  end
	has_rich_text :description

	extend FriendlyId
	friendly_id :title, use: :slugged

  def self.ransackable_attributes(auth_object = nil)
      ["created_at", "description", "id", "language", "level", "price", "short_description", "slug", "title", "updated_at", "user_id", "average_rating", "enrollments_count"]
  end
  def self.ransackable_associations(auth_object = nil)
      ["rich_text_description", "user"]
  end

  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
    def self.languages
      LANGUAGES.map { |language| [language, language] }
    end

    LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]
    def self.levels
      LEVELS.map { |level| [level, level] }
    end
  
  def bought(user)
    # self.enrollments.where(user_id: [user.id]).### when I changed to this I cannot see the lessons
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end

  def progress(user)
    unless self.lessons_count == 0
      user_lessons.where(user: user).count/self.lessons_count.to_f*100
    end
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  include PublicActivity::Model
   tracked owner: Proc.new{ |controller, model| controller.current_user }

end
