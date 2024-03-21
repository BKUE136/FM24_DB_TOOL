This is part of Football Manager Project

1. exporting the '*.rtf' from Footballmanager using a custom view

Edit '*.rft ' file  
Ctrl + H                    :   search      :   replace  
remove the r-EID            :   r-(\d+)     :   \1  
remove rows that start with :  '| --- _'    :   ^\|\s*---.*\R  

2. Create Databases in SQL

move '*.rtf' to ~/.gitignore

3. Importing '*.rtf' to table

*/  This is where the magic will happen  /*
*/  At the meantime it is just a matter of executing sql in your sql-manager    /*
