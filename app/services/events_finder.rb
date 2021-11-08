# frozen_string_literal: true

class EventsFinder
  def call(params, request_safe_location, current_user)
    find_events(params, request_safe_location, current_user)
      .preload(:performer, :venue, :rich_text_description, pictures_attachments: :blob)
      .paginate(page: params[:page], per_page: 2)
  end

  private

  def find_events(params, request_safe_location, current_user)
    case params[:filter]
    when 'keyword'
      Event.filter_by_keyword params[:keyword]
    when 'nearest'
      coords = if request_safe_location.coordinates.empty?
                 [50.4547, 30.5238]
               else
                 request_safe_location.coordinates
               end
      Event.nearest(VenuesWithDistanceFinder.call(coords).keys)
    else
      user_id = current_user.id if current_user
      Event.filter_by(params[:filter], user_id)
    end
  end
end
