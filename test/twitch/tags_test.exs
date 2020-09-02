defmodule Blur.Twitch.TagTest do
  use ExUnit.Case, async: true

  test "process twitch tags from a message" do
    tags = """
    @badge-info=;badges=global_mod/1,turbo/1;color=#0D4200;display-name=ronni;emotes=25:0-4,12-16/1902:6-10;id=b34ccfc7-4977-403a-8a94-33c6bac34fb8;mod=0;room-id=1337;subscriber=0;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=global_mod
    """

    msg = """
    :ronni!ronni@ronni.tmi.twitch.tv PRIVMSG #ronni :Kappa Keepo Kappa
    """

    {:privmsg, channel, user, message, tags} = Blur.Twitch.Tag.parse(tags, msg)

    assert channel === "#ronni"
    assert user.name === "ronni"
    assert message === "Kappa Keepo Kappa"
    %{"room-id" => roomid} = tags

    assert roomid === "1337"
  end

  test "parse CLEARMSG message" do
    cmd = """
    @login=<login>;target-msg-id=<target-msg-id>
    """

    msg = """
    :tmi.twitch.tv CLEARMSG #rockerboo :Cool kids
    """

    {:clearmsg, _channel, _msg, _tags} = Blur.Twitch.Tag.parse(cmd, msg)
  end

  test "parse CLEARCHAT messages" do
    cmd = ""
    msg = ":tmi.twitch.tv CLEARCHAT #dallas :ronni"

    {:clearchat, _channel, _user} = Blur.Twitch.Tag.parse(cmd, msg)
  end

  test "parse GLOBALUSERSTATE message" do
    cmd = """
    @badge-info=subscriber/8;badges=subscriber/6;color=#0D4200;display-name=dallas;emote-sets=0,33,50,237,793,2126,3517,4578,5569,9400,10337,12239;turbo=0;user-id=1337;user-type=admin 
    """

    msg = """
    :tmi.twitch.tv GLOBALUSERSTATE
    """

    {:globaluserstate, _user, _tags} = Blur.Twitch.Tag.parse(cmd, msg)
  end

  test "parse USERNOTICE message" do
    cmd = """
    @badge-info=;badges=staff/1,broadcaster/1,turbo/1;color=#008000;display-name=ronni;emotes=;id=db25007f-7a18-43eb-9379-80131e44d633;login=ronni;mod=0;msg-id=resub;msg-param-cumulative-months=6;msg-param-streak-months=2;msg-param-should-share-streak=1;msg-param-sub-plan=Prime;msg-param-sub-plan-name=Prime;room-id=1337;subscriber=1;system-msg=ronni\shas\ssubscribed\sfor\s6\smonths!;tmi-sent-ts=1507246572675;turbo=1;user-id=1337;user-type=staff
    """

    msg = """
    :tmi.twitch.tv USERNOTICE #dallas :Great stream -- keep it up!
    """

    {:usernotice, _channel, _msg, _tags} = Blur.Twitch.Tag.parse(cmd, msg)

    cmd = """
    @badge-info=;badges=staff/1,premium/1;color=#0000FF;display-name=TWW2;emotes=;id=e9176cd8-5e22-4684-ad40-ce53c2561c5e;login=tww2;mod=0;msg-id=subgift;msg-param-months=1;msg-param-recipient-display-name=Mr_Woodchuck;msg-param-recipient-id=89614178;msg-param-recipient-name=mr_woodchuck;msg-param-sub-plan-name=House\sof\sNyoro~n;msg-param-sub-plan=1000;room-id=19571752;subscriber=0;system-msg=TWW2\sgifted\sa\sTier\s1\ssub\sto\sMr_Woodchuck!;tmi-sent-ts=1521159445153;turbo=0;user-id=13405587;user-type=staff  
    """

    msg = """
    :tmi.twitch.tv USERNOTICE #forstycup
    """

    cmd = """
    @badge-info=;badges=broadcaster/1,subscriber/6;color=;display-name=qa_subs_partner;emotes=;flags=;id=b1818e3c-0005-490f-ad0a-804957ddd760;login=qa_subs_partner;mod=0;msg-id=anonsubgift;msg-param-months=3;msg-param-recipient-display-name=TenureCalculator;msg-param-recipient-id=135054130;msg-param-recipient-user-name=tenurecalculator;msg-param-sub-plan-name=t111;msg-param-sub-plan=1000;room-id=196450059;subscriber=1;system-msg=An\sanonymous\suser\sgifted\sa\sTier\s1\ssub\sto\sTenureCalculator!\s;tmi-sent-ts=1542063432068;turbo=0;user-id=196450059;user-type=
    """

    msg = """
    :tmi.twitch.tv USERNOTICE #qa_subs_partner
    """

    {:usernotice, _channel, _msg, _tags} = Blur.Twitch.Tag.parse(cmd, msg)

    cmd = """
    @badge-info=;badges=turbo/1;color=#9ACD32;display-name=TestChannel;emotes=;id=3d830f12-795c-447d-af3c-ea05e40fbddb;login=testchannel;mod=0;msg-id=raid;msg-param-displayName=TestChannel;msg-param-login=testchannel;msg-param-viewerCount=15;room-id=56379257;subscriber=0;system-msg=15\sraiders\sfrom\sTestChannel\shave\sjoined\n!;tmi-sent-ts=1507246572675;tmi-sent-ts=1507246572675;turbo=1;user-id=123456;user-type=
    """

    msg = """
    :tmi.twitch.tv USERNOTICE #othertestchannel
    """

    {:usernotice, _channel, _msg, _tags} = Blur.Twitch.Tag.parse(cmd, msg)

    cmd = """
    @badge-info=;badges=;color=;display-name=SevenTest1;emotes=30259:0-6;id=37feed0f-b9c7-4c3a-b475-21c6c6d21c3d;login=seventest1;mod=0;msg-id=ritual;msg-param-ritual-name=new_chatter;room-id=6316121;subscriber=0;system-msg=Seventoes\sis\snew\shere!;tmi-sent-ts=1508363903826;turbo=0;user-id=131260580;user-type=
    """

    msg = """
    :tmi.twitch.tv USERNOTICE #seventoes :HeyGuys
    """

    {:usernotice, _channel, _msg, tags} = Blur.Twitch.Tag.parse(cmd, msg)
  end

  test "parse USERSTATE message" do
    cmd = """
    @badge-info=;badges=staff/1;color=#0D4200;display-name=ronni;emote-sets=0,33,50,237,793,2126,3517,4578,5569,9400,10337,12239;mod=1;subscriber=1;turbo=1;user-type=staff
    """

    msg = """
    :tmi.twitch.tv USERSTATE #dallas
    """

    {:userstate, _channel, _msg, _tags} = Blur.Twitch.Tag.parse(cmd, msg)
  end

  test "parse ROOMSTATE message" do
    cmd = """
    @emote-only=0;followers-only=0;r9k=0;slow=0;subs-only=0
    """

    msg = """
    :tmi.twitch.tv ROOMSTATE #dallas
    """

    {:roomstate, _channel, _tags} = Blur.Twitch.Tag.parse(cmd, msg)
  end
end
