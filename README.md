# Japan National Budget Visualization Web Site

URL: [http://budget.civic-works.tokyo](http://budget.civic-works.tokyo)

Web site visualizing Japan's national budget data (originally based on [https://github.com/g0v/twbudget](https://github.com/g0v/twbudget)).

![jpbudget_thumbnail](https://raw.github.com/TOKYOCivicWorks/jpbudget/master/app/assets/img/thumbnail.png "jpbudget")

## Setup

### Install on Linux Ubuntu 18.04

	$ ./scripts/install.sh

### Prepare scripts/.setuprc

	export TWITTER_BEARER_TOKEN="AAAAAA..."  # Please obtain bearer token using Twitter API
	export TWITTER_AUTH_ENCRYPT_KEY="YOUR_OWN_KEY_ANY_WORD_IS_OK"

## Run

### On your local host during development

	$ ./scripts/start-all.sh -l

Then navigate your browser to http://(*LOCAL_HOST_IP*):8000, typing *testuser* & *jpbudget2020*.

### On external host for public (i.e. budget.civic-works.tokyo)

	$ ./scripts/start-all.sh -p

## How to Contribute

[How to contribute](https://raw.github.com/TOKYOCivicWorks/jpbudget/master/HOW_TO_CONTRIBUTE.md)

## License

[The MIT License](https://raw.github.com/TOKYOCivicWorks/jpbudget/master/LICENSE)

([Licenses for 3rd party software](https://raw.github.com/TOKYOCivicWorks/jpbudget/master/LICENSE_3RD_PARTY))
