Function Export-CroppedImage
{
    Get-ChildItem *.afm_3nm.jpg -Name |
        %{convert $_ -crop 512x512+48+80 $("crop/{0}_crop.jpg" -f
            [System.IO.Path]::GetFileNameWithoutExtension($_) ) }
}
