select * 
from NashvilleHousing


-- Standardize Date format

select SaleDateConverted, convert(Date, SaleDate)
from NashvilleHousing

alter table NashvilleHousing
add SaleDateConverted Date 

update NashvilleHousing
set SaleDateConverted = convert(Date,SaleDate)



-- Populate Property Address

select *
from NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress,  b.ParcelID, b.PropertyAddress, isnull( a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null

update a
set PropertyAddress = isnull( a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null



-- Breaking out Address into Individual columns(Address, City, State)

select PropertyAddress
from NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select substring(PropertyAddress, 1, charindex(',' , PropertyAddress) - 1) as Address,
substring(PropertyAddress, charindex(',' , PropertyAddress) + 1, len(PropertyAddress)) as Address
from NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255),
PropertySplitCity nvarchar(255)


update NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress, 1, charindex(',' , PropertyAddress) - 1),
PropertySplitCity = substring(PropertyAddress, charindex(',' , PropertyAddress) + 1, len(PropertyAddress))
from NashvilleHousing

select *
from NashvilleHousing



select parsename(replace(OwnerAddress,',','.'),3),
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),1)
from NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255),
OwnerSplitCity nvarchar(255),
OwnerSplitState nvarchar(255)


update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress,',','.'),3),
OwnerSplitCity = parsename(replace(OwnerAddress,',','.'),2),
OwnerSplitState = parsename(replace(OwnerAddress,',','.'),1)
from NashvilleHousing

select *
from NashvilleHousing



-- Change 1 and 0 to Yes and No in 'Sold as Vacant' column

select distinct(SoldAsVacant), count(SoldAsVacant) 
from NashvilleHousing
group by SoldAsVacant

alter table NashvilleHousing
add SoldAsVacant1 nvarchar(50) 

Update NashvilleHousing
set SoldAsVacant1 = case when SoldAsVacant = 0 then 'No'
		when SoldAsVacant = 1 then 'Yes'
		End

select SoldAsVacant, SoldAsVacant1
from NashvilleHousing



-- Remove Duplicates

with RownumCTE as (
select *,
row_number() over (partition by ParcelID, PropertyAddress, SalePrice,SaleDate, LegalReference order by UniqueID)  row_num
from NashvilleHousing
)
select *
from RownumCTE
where row_num > 1


-- Delete Unused Columns

select *
from NashvilleHousing

alter table NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SoldAsVacant

alter table NashvilleHousing
drop column SaleDate
