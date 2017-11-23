class PagesController < ApplicationController
  def home
    @rooms = Room.where(active: true).limit(3)
  end

  def search
    # Step 1
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end
    # .strip returns a copy of str with leading and trailing whitespace removed.

    # Step 2
    if session[:loc_search] && session[:loc_search] != ""
      @rooms_address = Room.where(active: true).near(session[:loc_search], 5, order: 'distance')
      # See geocoder gem @ https://github.com/alexreisner/geocoder for more infos
    else
      @rooms_address = Room.where(active: true).all
    end

    # Step 3
    @search = @rooms_address.ransack(params[:q])
    #params[:q] is generated by ransack (gem) from the form in search.html.erb
    @rooms = @search.result

    @arrRooms = @rooms.to_a

    # Step 4
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? && !params[:end_date].empty?)

      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @arrRooms.each do |room|
        notAvailable = room.reservations.where(
          "(? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date)",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date
        ).limit(1)

        if notAvailable.length > 0
          @arrRooms.delete(room)
        end
      end

    end
  end
end
