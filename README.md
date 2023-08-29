# CKArchitecture
Sample app to present:

- MVVM event-based architecture using Combine framework
- app Navigation built with enums
- parser based on enums that may parse data with different nested content (data structures)
Example:
Different API requests return a container having some same attributes but different data arrays depending on the requuest ([Person], [Planet] or [Film]).
The enum parser creats one function that is able to parse all these variations.
