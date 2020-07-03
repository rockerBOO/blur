defmodule Blur.ChannelTest do
  use ExUnit.Case

  doctest Blur.Channel

  describe "blur channel processes" do 
  	test "" do 
  		start_supervised!({Blur.Channel, []})
  	end
  end
end
