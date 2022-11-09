# Ads
Posting service API

## Dependencies:
```sh
ruby '3.1.0'
```
## Requests:
##
```sh
#create ad:
curl --request POST \
  --url http://localhost:9292/create \
  --header 'AUTHORIZATION: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.ImJjZjU1ODE3LTA3ZGQtNGY4Zi1hYWVkLWU4NTlkY2IyNjBiMSI.snSk3yzIMsqe8q4E0AT8UuhOP2-kj6A5WHbKaKjTo-0' \
  --header 'Content-Type: application/json' \
  --data '{
	"title": "have a new car in new place another one",
	"city": "Адыгейск",
	"description": "123"
}'
```
```sh
#login response:
201
```
```sh
#show ads:
curl --request GET \
  --url http://localhost:9292/
```
```sh
#login response:
[
	{
		"id": 2,
		"title": "new title",
		"description": "new ads",
		"user_id": 45,
		"city": "New york",
		"lat": null,
		"lon": null
	}
]
```