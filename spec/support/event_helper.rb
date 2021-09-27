# frozen_string_literal: true

module EventHelper
  def check_event_info(event)
    expect(page).to have_text(event.title)
    expect(page).to have_text(event.description[0...100])

    expect(page).to have_text(event.venue.name)
    expect(page).to have_text('Tickets left')
    e = event.decorate
    expect(page).to have_text(e.fee)
    expect(page).to have_text(e.start_end.gsub('  ', ' '))
  end

  def visit_first_event(admin)
    @user ||= create(:user, role: 1)
    login_as @user
    e = Event.first
    if admin
      user1 = create(:user)
      user2 = create(:user)
      order1 = create(:order, event_id: e.id, user_id: user1.id)
      order2 = create(:order, event_id: e.id, user_id: user2.id)
    end
    click_link e.title
    expect(page).to have_current_path event_path(e.id)
    check_event_info(e)
    if admin
      expect(page).to have_text(user1.email)
      expect(page).to have_text(user2.email)
      expect(page).to have_text(order1.quantity)
      expect(page).to have_text(order2.quantity)
    end
  end
end