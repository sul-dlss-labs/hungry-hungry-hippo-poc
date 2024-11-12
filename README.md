# Hungry-hungry-hippo (H3) Proof of Concept

## Development

### Prerequisites
* Tmux and Overmind (See https://github.com/DarthSim/overmind?tab=readme-ov-file#installation)

### Development server

```shell
# Ask a developer to get the secret key and pop that in `config/credentials/development.key`,
# which will allow authenticating with the DSA API.
bin/rails db:prepare
bin/dev
```
