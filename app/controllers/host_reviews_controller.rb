class HostReviewsController < ApplicationController

  def create
    # Step 1: Check if the reservation exist beetween room_id, guest_id and host_id

    # Step 2: Check if the current host already reviewed the guest for this reservation

    @reservation = Reservation.where(
                    id: host_review_params[:reservation_id],
                    room_id: host_review_params[:room_id],
                    user_id: host_review_params[:guest_id]
                   ).first

    if !@reservation.nil?
      @has_reviewed = HostReview.where(
                        reservation_id: @reservation.id,
                        guest_id: host_review_params[:guest_id]
                      ).first

      if @has_reviewed.nil?
        # Allow to review = because never reviewed before
        @host_review = current_user.host_reviews.create(host_review_params)
        flash[:success] = "Review created"
      else
        # Already reviewed
        flash[:notice] = "A review already exists for this reservation"
      end

    else
      flash[:alert] = "Reservation not found"
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @host_review = Review.find(params[:id])
    @host_review.destroy
    redirect_back(fallback_location: request.referer, notice: "Removed")
  end

  private
    def host_review_params
      params.require(:host_review).permit(:comment, :star, :room_id, :reservation_id, :guest_id)
    end
end
