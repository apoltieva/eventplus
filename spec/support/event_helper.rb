# frozen_string_literal: true

module EventHelper
  def check_event_info(event)
    expect(page).to have_text(event.title)
    expect(page).to have_text(event.venue.name)
    expect(page).to have_text('Tickets left')
  end

  def visit_first_event(admin, event)
    if admin
      user1 = create(:user)
      user2 = create(:user)
      order1 = create(:order, event_id: event.id, user_id: user1.id)
      order2 = create(:order, event_id: event.id, user_id: user2.id)
    end
    click_link event.title
    expect(page).to have_current_path event_path(event.id, locale: I18n.locale)
    check_event_info(event)
    return unless admin

    expect(page).to have_text(user1.email)
    expect(page).to have_text(user2.email)
    expect(page).to have_text(order1.quantity)
    expect(page).to have_text(order2.quantity)
  end
end
