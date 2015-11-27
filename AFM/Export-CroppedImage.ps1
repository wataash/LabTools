Get-ChildItem *.afm_3nm.jpg -Name |
    %{convert $_ -crop 512x512+48+80 $("crop/" + $_)}
