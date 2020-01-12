# PSGalleryExplorer - FAQ

## FAQs

### How current is the GitHub info that is included with PSGallery Explorer?

There can be up to a 1 week delay in corresponding PowerShell GitHub project data. This is solely due to cost. The [Serveless PowerShell solution](PowerShell_Serverless.md) in place cost compute time. As such, it's currently set to refresh approximately once per week.

### Why do you exclude common modules and corporate modules by default?

PSGalleryExplorer aims to aid in the discovery of modules. Simply put: common/popular modules and corporate modules tend to dominate the metrics by a wide margin. This can make it challenging to discover new/upcoming/trending modules. So, by default they are excluded from results. Keep in mind there are parameters to easily include them in your results.

If you feel like a module should be added/excluded please open an issue for discussion.
