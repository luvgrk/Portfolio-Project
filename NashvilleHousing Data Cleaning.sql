-- Cleaning Data in SQL Queries

Select *
From NashvilleHousing;

-- Populate Property Address Data

Select ParcelID
From NashvilleHousing
Where PropertyAddress is  null;

Select a.parcelID, a.PropertyAddress, b.parcelID, b.PropertyAddress, IFNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	on a.parcelID = b.parcelID 
    and a.UniqueID != b.UniqueId
Where a.PropertyAddress is null;

Update NashvilleHousing a
Join NashvilleHousing b
	on a.parcelID = b.parcelID 
    and a.UniqueID != b.UniqueId
Set a.PropertyAddress = b.PropertyAddress
Where a.PropertyAddress is null;

-- Breaking out Address into Individual Columns 

Select PropertyAddress
From NashvilleHousing;

Select 
Substring(PropertyAddress, 1, locate(',', PropertyAddress) -1) as Address, 
Substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress)) as Address
From NashvilleHousing;

Alter Table NashvilleHousing
Add PropertySplitAddress varchar(500);

Update NashvilleHousing
Set PropertySplitAddress = Substring(PropertyAddress, 1, locate(',', PropertyAddress) -1);

Alter Table NashvilleHousing
Add PropertySplitCity varchar(500);

Update NashvilleHousing
Set PropertySplitCity = Substring(PropertyAddress, locate(',', PropertyAddress) +1, length(PropertyAddress));


Select OwnerAddress
From NashvilleHousing;
