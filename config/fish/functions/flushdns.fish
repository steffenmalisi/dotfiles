function flushdns
    dscacheutil -flushcache && killall -HUP mDNSResponder
end