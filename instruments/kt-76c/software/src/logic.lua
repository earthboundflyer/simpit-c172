--[[
	Bendix-King KT 76C Transponder Prototype Code
  2020-11-29
--]]

-- globals ---
local xpndr = { mode = 0, code = 1200, flight_level = 0, ident = 0, powered = 0 }

-- display ---
display_chr_xpndr = hw_chr_display_add("Transponder", "MAX7219", 1)

-- callbacks ---

function xpndr_code_update(code)
    xpndr.code = code
    update_display()
end

function xpndr_mode_update(mode)
    xpndr.mode = mode
    update_display()
end

function xpndr_ident_update(ident)
    xpndr.ident = ident
    update_display()
end

function altitude_update(altitude)
    flight_level = math.floor(altitude / 100)

    if (xpndr.flight_level ~= flight_level) then -- only update flight level if changed
        xpndr.flight_level = flight_level
        update_display()
    end
end

function update_display()

    if xpndr.powered == 1 then
        if xpndr.mode == 0 then
            print("xpndr mode OFF")
            hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format("0ff %04d", xpndr.code))
        elseif xpndr.mode == 1 then
            print("xpndr mode STBY")
            hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format("    %04d", xpndr.code))
        elseif xpndr.mode == 2 then
            print("xpndr mode ON")
            if (xpndr.ident == 1) then
                hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format(" 0n .%04d", xpndr.code))
            else
                hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format(" 0n %04d", xpndr.code))
            end
        elseif xpndr.mode == 3 then
            print("xpndr mode ALT")
            if (xpndr.ident == 1) then
                hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format("%03d .%04d", xpndr.flight_level, xpndr.code))
            else
                hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format("%03d %04d", xpndr.flight_level, xpndr.code))
            end
        elseif xpndr.mode == 4 then
            print("xpndr TEST")
            hw_chr_display_set_text(display_chr_xpndr, 0, 0, string.format("    %04d", xpndr.code))
        end
    else
        hw_chr_display_set_text(display_chr_xpndr, 0, 0, "        ") -- clear the display
    end
end

function avionics_master_update(avionics_master_on)
    xpndr.powered = avionics_master_on
    update_display()
end

function button_pressed_xpndr_0()
    print("xpndr button 0 pressed")
    xpl_command("sim/transponder/transponder_digit_0")
end

function button_pressed_xpndr_1()
    print("xpndr button 1 pressed")
    xpl_command("sim/transponder/transponder_digit_1")
end

function button_pressed_xpndr_2()
    print("xpndr button 2 pressed")
    xpl_command("sim/transponder/transponder_digit_2")
end

function button_pressed_xpndr_3()
    print("xpndr button 3 pressed")
    xpl_command("sim/transponder/transponder_digit_3")
end

function button_pressed_xpndr_4()
    print("xpndr button 4 pressed")
    xpl_command("sim/transponder/transponder_digit_4")
end

function button_pressed_xpndr_5()
    print("xpndr button 5 pressed")
    xpl_command("sim/transponder/transponder_digit_5")
end


function button_pressed_xpndr_6()
    print("xpndr button 6 pressed")
    xpl_command("sim/transponder/transponder_digit_6")
end

function button_pressed_xpndr_7()
    print("xpndr button 7 pressed")
    xpl_command("sim/transponder/transponder_digit_7")
end

function button_pressed_ident()
    print("xpndr button ident pressed")
    xpl_command("sim/transponder/transponder_ident")
end

function button_pressed_clear()
    print("xpndr button clear pressed")
    xpl_command("sim/transponder/transponder_CLR")
end

function button_pressed_vfr()
    print("xpndr button vfr pressed")
    xpl_dataref_write("sim/cockpit2/radios/actuators/transponder_code", "int", 1200)
end

function button_pressed_standby()
    print("xpndr button sby pressed")
    xpl_command("sim/transponder/transponder_standby")
end

function button_pressed_on()
    print("xpndr button on pressed")
    xpl_command("sim/transponder/transponder_on")
end

function button_pressed_alt()
    print("xpndr button alt pressed")
    xpl_command("sim/transponder/transponder_alt")
end

function button_pressed_test()
    print("xpndr button test pressed")
    xpl_command("sim/transponder/transponder_test")
end

-- hardware ---

hw_button_add("Transponder 0", button_pressed_xpndr_0)
hw_button_add("Transponder 1", button_pressed_xpndr_1)
hw_button_add("Transponder 2", button_pressed_xpndr_2)
hw_button_add("Transponder 3", button_pressed_xpndr_3)
hw_button_add("Transponder 4", button_pressed_xpndr_4)
hw_button_add("Transponder 5", button_pressed_xpndr_5)
hw_button_add("Transponder 6", button_pressed_xpndr_6)
hw_button_add("Transponder 7", button_pressed_xpndr_7)
hw_button_add("Transponder Ident", button_pressed_ident)
hw_button_add("Transponder Clear", button_pressed_clear)
hw_button_add("Transponder VFR", button_pressed_vfr)
hw_button_add("Transponder Standby", button_pressed_standby)
hw_button_add("Transponder On", button_pressed_on)
hw_button_add("Transponder Alt", button_pressed_alt)
hw_button_add("Transponder Test", button_pressed_test)

-- data refs ---
xpl_dataref_subscribe("sim/cockpit/radios/transponder_code", "int", xpndr_code_update)
xpl_dataref_subscribe("sim/cockpit/radios/transponder_mode", "int", xpndr_mode_update)
xpl_dataref_subscribe("sim/cockpit/radios/transponder_id", "int", xpndr_ident_update)
xpl_dataref_subscribe("sim/cockpit2/gauges/indicators/altitude_ft_pilot", "float", altitude_update)
xpl_dataref_subscribe("sim/cockpit2/switches/avionics_power_on", "int", avionics_master_update)
