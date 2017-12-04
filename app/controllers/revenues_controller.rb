class RevenuesController < ApplicationController
  before_action :authenticate_user!

  def index
    # @reservations = [ReservationObject1, ReservationObject2, ...]

    @reservations = Reservation.current_week_revenue(current_user)

    # a = ["a", "b", "c"]
    # a.map {|x| x + "!"} ===> returns ["a!", "b!", "c!"]

    # 1) map returns: [{"2017-11-29"=>258}, {"2017-11-29"=>387}, {"2017-11-29"=>698}, {"2017-11-29"=>1047}, ...]
    # 2) inject returns: {"2017-11-29"=>2390, "2017-12-01"=>258, "2017-12-02"=>1783, "2017-12-04"=>645}

    # MERGE
    # h1 = { "a" => 100, "b" => 200 }
    # h2 = { "b" => 254, "c" => 300 }
    # h1.merge(h2)   => {"a"=>100, "b"=>254, "c"=>300}
    # h1.merge(h2){|key, oldval, newval| newval - oldval}
    #                => {"a"=>100, "b"=>54,  "c"=>300}

    # INJECT
    # (5..10).inject {|sum, n| sum + n }

    @this_week_revenue = @reservations.map {|r| {r.updated_at.strftime("%Y-%m-%d") => r.total} }
                                      .inject({}) {|sum,n| sum.merge(n){|key,oldval,newval| oldval + newval}}

    # Date.today().all_week returns an array of all the days of the current week from Monday to Sunday

    @this_week_revenue = Date.today().all_week.map{ |date| [date.strftime("%a"), @this_week_revenue[date.strftime("%Y-%m-%d")] || 0 ] }

    # returns [["Mon", 645], ["Tue", 0], ["Wed", 0], ["Thu", 0], ["Fri", 0], ["Sat", 0], ["Sun", 0]]
  end
end
