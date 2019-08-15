$files = (
'variables.tf',
'main.tf',
'outputs.tf',
'LAB-Guide.md'
)

$folders = (
'LAB01',
'LAB02',
'LAB03',
'LAB04',
'LAB05',
'LAB06',
'LAB07',
'LAB08'
)

ForEach($folder in $folders)
{ 
    $Folder = New-Item -Path $PSScriptRoot -Name $Folder -ItemType Directory -Force

    ForEach($file in $files)
    {
    
        New-Item -Path $Folder.FullName -Name $file -ItemType File -Force
    
    }

}