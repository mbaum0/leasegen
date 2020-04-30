#!/bin/bash

create_zip() {
    mkdir -p temp
    cp RESIDENTIAL_LEASE_AGREEMENT_FORM.docx temp/temp.zip
    cd temp
    unzip temp.zip > /dev/null 2>&1
    rm temp.zip
    cd ..
}


get_terms() {
    read -p "Enter signing year (eg. 2020): " s_year
    read -p "Enter signing month (eg. April): " s_month
    read -p "Enter signing day (eg. 1st, 2nd, 29th): " s_day

    read -p "Enter rental address (eg. 1 Kettlebrooke Dr, Rochester, NY 14001): " property_address

    read -p "Enter start year (eg. 2020): " b_year
    read -p "Enter start month (eg. April): " b_month
    read -p "Enter start day (eg. 1st, 2nd, 29th): " b_day
    read -p "Enter end year (eg. 2020): " e_year
    read -p "Enter end month (eg. April): " e_month
    read -p "Enter end day (eg. 1st, 2nd, 29th): " e_day

    read -p "Enter the monthly rental rate (eg. 575, no dollar sign): " rate
}


get_parties() {
    read -p "Enter landlord name (eg. Jason Bourn): " ll_name
    read -p "Enter landlord address (eg. eg. 1 Kettlebrooke Dr, Rochester, NY 14001): " ll_address
    read -p "Enter landlord phone (eg. 555-555-5555): " ll_phone
    read -p "Enter landlord email (eg. mail@mail.com): " ll_email

    read -p "Enter tenant name (eg. Jason Bourn): " t_name
    read -p "Enter tenant address (eg. 1 Kettlebrooke Dr, Rochester, NY 14001): " t_address
    read -p "Enter tenant phone (eg. 555-555-5555): " t_phone
    read -p "Enter tenant email (eg. mail@mail.com): " t_email
}


edit_docx() {
    cd temp/word
    sed -i "s/SYEAR/$s_year/g" document.xml
    sed -i "s/SMONTH/$s_month/g" document.xml
    sed -i "s/SDAY/$s_day/g" document.xml

    sed -i "s/BYEAR/$b_year/g" document.xml
    sed -i "s/BMONTH/$b_month/g" document.xml
    sed -i "s/BDAY/$b_day/g" document.xml

    sed -i "s/FYEAR/$e_year/g" document.xml
    sed -i "s/FMONTH/$e_month/g" document.xml
    sed -i "s/FDAY/$e_day/g" document.xml

    sed -i "s/PROPERTYADDRESS/$property_address/g" document.xml
    sed -i "s/RATE/$rate/g" document.xml

    sed -i "s/LLNAME/$ll_name/g" document.xml
    sed -i "s/LLADDRESS/$ll_address/g" document.xml
    sed -i "s/LLPHONE/$ll_phone/g" document.xml
    sed -i "s/LLEMAIL/$ll_email/g" document.xml

    sed -i "s/TNAME/$t_name/g" document.xml
    sed -i "s/TADDRESS/$t_address/g" document.xml
    sed -i "s/TPHONE/$t_phone/g" document.xml
    sed -i "s/TEMAIL/$t_email/g" document.xml

    cd ..
    f_name="$t_name - Lease Agreement - $b_year.docx"
    zip -r "$f_name" * > /dev/null 2>&1
    mv "$f_name" ..
    cd ..
}



# s_day="29th"
# s_month="April"
# s_year="2020"
# b_day="15th"
# b_month="June"
# b_year="2020"
# e_day="30th"
# e_month="August"
# e_year="2020"
# property_address="1 Fakewood Dr, Rochester, NY 14601"
# rate="575"
# ll_name="Landlord Name"
# ll_address="1 Fakeroad Rd, Rochester, NY 14601"
# ll_phone="555-555-5555"
# ll_email="email@emailz.com"
# t_name="John Tenant"
# t_address="2 Essex Street, Rochester, NY 14645"
# t_phone="555-555-1234"
# t_email="temail@emailz.com"

get_parties
get_terms

echo "Lease Details"
echo ""
echo "  Terms"
echo "   Sign Date: $s_day day of $s_month $s_year"
echo "   Address: $property_address"
echo "   Start Date: $b_day day of $b_month $b_year"
echo "   End Date: $e_day day of $e_month $e_year"
echo "   Monthly Rate: \$$rate"
echo ""
echo "  Parties"
echo "    Landlord: $ll_name"
echo "              $ll_address"
echo "              $ll_phone"
echo "              $ll_email"
echo "    Tenant:   $t_name"
echo "              $t_address"
echo "              $t_phone"
echo "              $t_email"


read -r -p "Does everything look correct? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    create_zip
    edit_docx
    rm -r temp
    echo
    echo "New lease created: $f_name"
else
    do_something_else
fi


