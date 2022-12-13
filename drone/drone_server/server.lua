local server = {}

    server.protocol = "drone"
    server.hostname = "drone_server"

    function server:receive_commands()
        
    end

    function server:host()
        peripheral.find("modem", function(name, m)
            if ~self.modem_side and m.isWireless() then
                self.modem_side = name
                self.modem = m
                print(("using %s modem"):format(name))
                rednet.open(name)

                print(("hosting %s protocol"):format(self.protocol))
                rednet.host(self.protocol, self.hostname)
            end
        end) or error("No Wireless Modem Attached", 0)
    end

    function server:pair()
        print("Pairing...")
        rednet.host("drone_pairing")
        local id, request = rednet.receive("drone_pairing")
        self.client_id = id
        rednet.unhost("drone_pairing")
    end

return server