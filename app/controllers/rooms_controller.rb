class RoomsController < ApplicationController

  before_action :find_room, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorized, only: [:listing, :pricing,
                                       :description, :photo_upload,
                                       :amenities, :location, :update]

  def index
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.new
  end

  def create
    @room = current_user.rooms.new(room_params)
    if @room.save
      redirect_to listing_room_path(@room), notice: "Saved"
    else
      flash[:alert] = "Something went wrong"
      render :new
    end
  end

  def show
    @photos = @room.photos
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @room.photos
  end

  def amenities
  end

  def location
  end

  def update
    new_params = room_params
    new_params = room_params.merge(active: true) if room_is_ready?

    if @room.update(new_params)
      flash[:notice] = "Saved"
    else
      flash[:alert] = "Something went wrong"
    end
    redirect_back(fallback_location: request.referer)
  end

  # RESERVATIONS
  def preload
    today = Date.today
    reservations = @room.reservations.where("start_date >= ? OR end_date >= ?", today, today)
    render json: reservations
    # envoi en réponse un tableau d'objets Reservation au format json : [{}, {}]
  end

  def preview
    # binding.pry
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: conflict_found?(start_date, end_date, @room)
    }

    render json: output
  end

  private

    def room_params
      params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room,
                                   :bath_room, :listing_name, :summary, :address,
                                   :is_tv, :is_kitchen, :is_air, :is_heating,
                                   :is_internet, :price, :active, :latitude, :longitude)
    end

    def find_room
      @room = Room.find(params[:id])
    end

    def is_authorized
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @room.user_id
    end

    def room_is_ready?
      !@room.active && !@room.price.blank? && !@room.listing_name.blank? && !@room.photos.blank? && !@room.address.blank?
    end

    def conflict_found?(start_date, end_date, room)
      overlapping_reservations = room.reservations.where("? < start_date AND end_date < ?", start_date, end_date)
      overlapping_reservations.size > 0
    end

end
