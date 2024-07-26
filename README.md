Infrastructure-as-code for SIBR's server. Status: Early work in progress, not yet production

Operations documentation:

- [Common operations tasks](./docs/ops.md)
- [Setting up from scratch](./docs/setup.md)

## Minimum Viable Context

The [Society for Blaseball Research](https://sibr.dev/) is a fandom community around [_Blaseball_](https://en.wikipedia.org/wiki/Blaseball), which was a live service game that operated between 2020 and 2023. The game simulated a baseball league and allowed fans to vote to change the league.

SIBR members built tools to record, archive, and analyze game data. Shortly after _Blaseball_ began, we colocated these tools on shared infrastructure to keep the evergrowing number of things to keep track of as small as possible. We also began to provide hosting to other fan projects, including [the Blaseball Wiki](https://blaseball.wiki/) and [Blaseball News Network](https://blaseball.news/).

At the end of _Blaseball_, SIBR had two dedicated servers its services were split between. This repository reflects work after the end of _Blaseball_ to migrate services onto a single server, with the goal to document the setup as much as possible to reduce recovery time in the event of a hardware failure. Most of the data that's used to run these services is (expected to become) publicly available, so this repository can also serve as a guide for how to spin up your own replica of most of SIBR's services.

The server runs Ubuntu 24.04 LTS. The system state is managed as best as we can with Ansible.

Services are generally contained within Docker Compose stacks. A handful of these stacks will be found in this repository. Some are run by community members who don't have root access to the server; we expect that management for these stacks will be delegated using Portainer.
