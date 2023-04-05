## Why vendor 3rd party libs?

Docs for mix archive.build

- https://hexdocs.pm/mix/1.12/Mix.Tasks.Archive.Build.html

> > For instance, archives do not include dependencies, as those would conflict with any dependency in a Mix project after the archive is installed

To have a workaround, we have included Virtfs and TypedStruct lib files directly into `lib/vendor` folder. We'll probably burn in hell for this cardinal sin sometime, but for now it kinda works.
