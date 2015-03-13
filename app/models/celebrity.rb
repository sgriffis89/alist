class Celebrity < ActiveRecord::Base
  has_many :celebrity_votes

  accepts_nested_attributes_for :celebrity_votes
  validates_uniqueness_of :first_name, scope: [:last_name]

  scope :active, -> { where("active") }

  require 'wikipedia'


  def wikipedia_url
    if self.last_name.blank?
      page = Wikipedia.find("#{self.first_name}  (entertainer)" )
    else
      page = Wikipedia.find("#{self.first_name}  #{self.last_name}" )
    end
    page.image_urls[0]
  end

  def graph_data
    votes = self.celebrity_votes.group(:vote_value).count
    total_votes = self.celebrity_votes.count

    if total_votes > 0
      #return   {"A List" => (votes[1].nil? ? 0 : votes[1]) / total_votes.to_f,
      #   "B List" => (votes[2].nil? ? 0 : votes[2]) / total_votes.to_f,
      #   "C List" => (votes[3].nil? ? 0 : votes[3]) / total_votes.to_f,
      #   "D List" => (votes[4].nil? ? 0 : votes[4]) / total_votes.to_f
      #  }
      return[(votes[1].nil? ? 0 : votes[1]),
             (votes[2].nil? ? 0 : votes[2]),
             (votes[3].nil? ? 0 : votes[3]),
             (votes[4].nil? ? 0 : votes[4]),
             total_votes]
    else
      return []
    end
  end

  def self.search(search, page)
    paginate :per_page => 5, :page => page,
           :conditions => ['name ilike ?', "%#{search}%"], :order => 'name'
  end

end
