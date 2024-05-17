
### Compound vs. divided package structure

The ability to manage representations or representation parts
separately is required because the digital data submissions can be very
large. This is not only relevant for storing the AIP, it also concerns the SIP
which might need to be divided before the data is submitted to the repository.
In addition, it is important to find and identify AIP segments when creating a
DIP which relies on metadata or content of these segments.

In the following, two approaches for defining the structure of the IP will be
described with a focus on requirements of the AIP format: the *compound*
structure is represented by one single structural metadata file, and the
*divided* structure has one structural metadata file that references those of
individual representations. An example will help to describe the two
alternatives.

If the *compound* METS structure is used, as shown in Figure [3](#fig3), a
single METS file contains all references to metadata and data files contained in
the IP.

<a name="fig3"></a>
![Information Package structure](figs/visio/fig_3_mets_root.svg "One METS file in the root of the IP references all metadata and data files")

**Figure 3:**
One METS file in the root of the package references all metadata and data files

Even though the number suffix of the folders `rep-001` and `rep-002` of the
example shown in Figure [3](#fig3) suggests an order of representations, there
are no requirements regarding the naming of folders containing the
representations. The order of representations and the relations between them is
defined by the structural and preservation metadata.

If the *divided* METS structure is used, as shown in Figure [4](#fig4), then a
separate METS file for each representation exists which are referenced by the
root METS file. The example shown in Figure [4](#fig4) has a METS file in the
IP’s root which points to the METS files `Representations/Rep-001/METS.xml` and
`Representations/Rep-002/METS.xml`.

<a name="fig4"></a>
![Information Package structure](figs/visio/fig_4_mets_root.svg "Root METS file references METS files of the different representations")

**Figure 4:**
Root METS file references METS files of the different representations

The reason why this alternative was introduced is that it makes it easier to
manage representations independently from each other. This can be desired for
very large representations, in terms of file size or the amount of files (making
the root METS difficult to work with).

As a corollary of this division method we define, a
representation-based division as the separation of representations in different
folders under the `representations` folder as shown in the example of Figure
[4](#fig4). We also define a size-based division as the
separation of representation parts. To illustrate this, Figure [5](#fig5) shows
an example where a set of files belongs to the same representation (here named
`binary`) and is referenced in two separate physical containers (here named {C1}
and {C2} respectively). A key requirement when using size-based division of a
representation is that there must not be any overlap in the structure of the
representations, and that each sub-folder path must be unique across the
containers where the representation parts together constitute a representation
entity. Note that for this reason a numerical suffix is added to the
representation METS files, to avoid overwriting representation METS files when
automatically merging the divided representation back into one single physical
representation.

<a name="aip-rep-div-name"></a>**AIP1**: If a representation is divided
into parts, the representation component MUST use the same name in the different
containers.

<a name="aip-rep-div-overlap"></a>**AIP2**: If a representation is
divided into parts, each the sub-paths of items (folders and files) MUST be
unique across the different containers. This allows aggregating representation
parts without accidentally overwriting folders or files.

<a name="fig5"></a>
![Information Package structure](figs/visio/fig_5_mets_root.svg "Example of an IP.")

**Figure 5:**
Example of an IP.

For example, let us assume an AIP with two representations, each of which
consists of a set of three files. In the first representation all data files
are in the Open Document Format (ODT) and in the second one - as a derivative
of the first representation - all files are in the Portable Document Format
(PDF).

Note that in Figure [4](#fig4) and Figure [5](#fig5) there is no folder for descriptive metadata on the representation level.
The reason for this is that new representations are added as a new form for persisting and visualising the content. 
Metadata specific to the representation are usually technical or preservation metadata. Descriptive metadata relate to the 
intellectual entity and should be maintained on the root level. 

<a name="parentchild"></a>aipstruct

### Life-cycle of information packages organised in parent-Child relationship

Assuming that a new AIP (e.g. containing an additional representation) needs to be added after parent- and child-AIPs have been stored, the recreation of the
whole logical AIP might be inefficient, especially if the AIPs are very large.

For this reason, existing child-AIPs remain unchanged in case a new version of the parent-AIP is created. Only the new version of the parent-AIP has references
to all child-AIPs as illustrated in Figure [7](#fig13). As a consequence, in order to find all siblings of a single child-AIP it is necessary to get the latest
version of the parent-AIP which implies the risk that the integrity of the logical AIP is in danger if the latest version of the parent-AIP is lost.

<a name="fig7"></a>
![Information Package structure](figs/visio/fig_13_new_aip_parent.svg "New version of a parent-AIP."){ width=382px }

**Figure 7:**
New version of a parent-AIP

The result of this process is a sequence of physical containers of child-AIPs
plus one additional parent-AIP. The relation of the AIPs is expressed by means
of structural metadata in the METS files.

<a name="metsid"></a>

### METS identifier

Each AIP root METS document must be assigned a persistent and unique
identifier. Possible identifier schemes are amongst others: OCLC Purls[^4], CNRI
Handles[^5], DOI[^6]. Alternatively, it is possible to use a UUID as a locally
unique identifier.[^7]

[^4]: http://purl.org/docs/index.html
[^5]: http://www.handle.net
[^6]: https://www.doi.org
[^7]: Universally Unique Identifier according to RFC 4122, http://tools.ietf.org/html/rfc4122.html

Using this identifier, the system must be able to retrieve the corresponding
package from the repository.

According to the Common Specification, any ID element must start with a prefix
(also, the XML ID data type does not permit IDs that start with a number, so a
prefix solves this issue).

It is recommended to use an internationally recognized standard identifier for the
institution from which the SIP originates as a prefix. This may lead to problems
with smaller institutions, which do not have any such internationally recognized
standard identifier. We propose in that case, to start the prefix with the
internationally recognized standard identifier of the institution, where the
AIP is created, augmented by an identifier for the institution from which the
SIP originates.

An alternative to this is to use a UUID:

    https://tools.ietf.org/html/rfc4122

The prefix `urn:uuid:` would indicate the identifier type. For example, if the
package identifier value is
`"123e4567-e89b-12d3-a456-426655440000"` this would be the value of the METS root
element’s `OBJID` attribute:

    /mets/@OBJID="urn:uuid:123e4567-e89b-12d3-a456-426655440000"

The `OBJID` attribute of the root METS is the persistent unique identifier of
the AIP.

#### Structural map of a divided METS structure

<a name="aip-divided-mets"></a>**AIP3**: When an AIP uses the
divided METS structure, i.e. the different representations have their own
METS file, the mandatory `<structMap>` MUST organize those METS files
through `<mptr>` and `<fptr>` entries, for each representation. The `<mptr>`
node MUST reference the `/<representation>/METS.xml` and point at the
corresponding `<file>` entry in the `<fileSec>` using the `<fptr>` element.

```xml
<structMap ID="uuid-1465D250-0A24-4714-9555-5C1211722FB8" TYPE="PHYSICAL" LABEL="CSIP structMap">
   <div ID="uuid-638362BC-65D9-4DA7-9457-5156B3965A18" LABEL="uuid-4422c185-5407-4918-83b1-7abfa77de182">
     <div LABEL="representations/images_mig-1">
       <mptr xlink:href="./representations/images_mig-1/METS.xml" xlink:title="Mets file describing representation: images_mig-1 of AIP: urn:uuid:d7ef386d-275b-4a5d-9abf-48de9c390339." LOCTYPE="URL" ID="uuid-c063ebaf-e594-4996-9e2d-37bf91009155"/>
       <fptr FILEID="uuid-fb9c37e7-1c90-4849-a052-1875e67853d5"/>
     </div>
     <div LABEL="representations/docs_mig-1">
       <mptr xlink:href="./representations/docs_mig-1/METS.xml" xlink:title="Mets file describing representation: docs_mig-1 of AIP: urn:uuid:d7ef386d-275b-4a5d-9abf-48de9c390339." LOCTYPE="URL" ID="uuid-335f9e55-17b2-4cff-b62f-03fd6df4adbf"/>
       <fptr FILEID="uuid-3f2268cd-7da9-4ad8-909b-4f17730dacaf"/>
     </div>
   </div>
</structMap>
```

**Listing 1:**
Structural map referencing METS files of the different representations

### Metadata representation of the AIP structure

#### Child AIP references parent AIP

The optional reference to a parent AIP is expressed by a structural map with the
LABEL attribute value `Parent`. Listing 2 shows an example where a UUID is used
as the package identifier and the `xlink:href` attribute has the UUID identifier
value of the referenced parent AIP as value. This identifier implicitly
references the METS file of the corresponding package. If other locator
types, such as URN, URL, PURL, HANDLE, or DOI are used, the `LOCTYPE` attribute
can be set correspondingly.

```xml
<structMap ID="uuid-35CB3341-D731-4AC3-9622-DB8901CD6736" TYPE="PHYSICAL" LABEL="parent AIP">
    <div ID="uuid-35CB3341-D731-4AC3-9622-DB8901CD6738" LABEL="AIP parent identifier">
      <mptr xlink:href="urn:uuid:3a487ce5-63cf-4000-9522-7288e208e2bc"
            xlink:title="Referencing the parent AIP of this AIP
                         (URN:UUID:3218729b-c93c-4daa-ad3c-acb92ab59cee)."
            LOCTYPE="OTHER" OTHERLOCTYPE="UUID"
            ID="uuid-755d4d5f-5c5d-4751-9652-fcf839c7c6f2"/>
    </div>
</structMap>
```

**Listing 2:**
Using a structMap to reference the parent AIP

#### Parent AIP references child AIPs
The parent AIP which is referenced by child AIPs must have a structural map
listing all child AIPs. Listing 3 shows the structural map of a parent AIP
listing four child AIPs.

```xml
<structMap TYPE="PHYSICAL" LABEL="child AIPs">
    <div LABEL="child AIPs">
        <div LABEL="child AIP">
            <mptr xlink:href="urn:uuid:cea73348-741d-4594-ab8f-0b9e652c1099"
                  xlink:title="Referencing a child AIP."
                  LOCTYPE="OTHER" OTHERLOCTYPE="UUID"
                  ID="uuid-d98e416f-55a7-4237-8d45-59c22d221669"/>
        </div>
        <div LABEL="child AIP">
            <mptr xlink:href="urn:uuid:cea73348-741d-4594-ab8f-0b9e652c1099"
                  xlink:title="Referencing a child AIP."
                  LOCTYPE="OTHER" OTHERLOCTYPE="UUID"
                  ID="uuid-70f8ec28-23f1-4364-9163-b3e99165b6e6"/>
        </div>
        <div LABEL="child AIP">
            <mptr xlink:href="urn:uuid:3218729b-c93c-4daa-ad3c-acb92ab59cee"
                  xlink:title="Referencing a child AIP."
                  LOCTYPE="OTHER" OTHERLOCTYPE="UUID"
                  ID="uuid-77373d7f-e241-481b-bf89-675335beb049"/>
        </div>
        <div LABEL="child AIP">
            <mptr xlink:href="urn:uuid:cea73348-741d-4594-ab8f-0b9e652c1099"
                  xlink:title="Referencing a child AIP."
                  LOCTYPE="OTHER" OTHERLOCTYPE="UUID"
                  ID="uuid-3f0cc05c-f27d-499d-a6fd-63bdfed13cb0"/>
        </div>
    </div>
</structMap>
```

**Listing 3:**
Using a structMap to reference the parent AIP

## AIP preservation metadata

As already mentioned, PREMIS [@premis3.0-2017] is used to describe technical
metadata of digital objects, rights metadata to define the rights status in
relation to specific agents or for specific objects, and to record events that
are relevant regarding the digital provenance of digital objects.

Regarding general use of PREMIS, there is the E-ARK Content Information Type
Specification for Preservation Metadata using PREMIS [^8]

[^8]: https://citspremis.dilcis.eu/specification/CITS_Preservation_metadata_v1.0.pdf      

In the following, only the PREMIS elements which are relevant for the AIP
format are described. **NOTE:** in the listings showing PREMIS
code parts, the prefix "premis" is omitted (default namespace is the PREMIS
namespace[^9]) while the "mets" prefix is explicitly added if a relation to the
METS file is explained.

[^9]: Namespace: http://www.loc.gov/premis/v3, namespace schema location:
       http://www.loc.gov/standards/premis/premis.xsd

### PREMIS object

The PREMIS object contains technical information about a digital object.

#### File format

<a name="aip-premis-file-format"></a>**AIP7**: The format
element COULD be provided either using the formatRegistry or the
formatDesignation element sub-elements, or both.

<a name="aip-premis-file-format-puid"></a>**AIP8**:
Regarding the formatRegistry, the Persistent Unique Identifier (PUID)[^10]
based on the PRONOM technical registry[^11] COULD be used.

[^10]: http://www.nationalarchives.gov.uk/aboutapps/pronom/puid.htm
[^11]: http://www.nationalarchives.gov.uk/PRONOM

An example is shown in Listing 6.

```xml
<format>
    <formatDesignation>
        <formatName>XML</formatName>
        <formatVersion>1.0</formatVersion>
    </formatDesignation>
    <formatRegistry>
    	<formatRegistryName>PRONOM</formatRegistryName>
    	<formatRegistryKey>fmt/101</formatRegistryKey>
    	<formatRegistryRole>specification</formatRegistryRole>
    </formatRegistry>
</format>
```

**Listing 6:**
Optionally, the format version can be provided using the `formatDesignation` element.

#### Storage

<a name="aip-premis-storage"></a>**AIP11**: The storage element
COULD hold contain information about the physical location of the digital
object.

Ideally this is a resolvable URI, but it can also generally hold information
needed to retrieve the digital object from the storage system (e.g. access
control or for segmented AIPs).

An example is shown in Listing 9.

```xml
<storage>
    <contentLocation>
        <contentLocationType>URI</contentLocationType>
        <contentLocationValue>
          /path/to/file.txt
        </contentLocationValue>
    </contentLocation>
    <storageMedium>hard disk HD2253</storageMedium>
</storage>
```

**Listing 9:**
Storage description

#### Relationship

<a name="aip-premis-relationship"></a>**AIP12**: The
`relationship` element SHOULD be used to describe relationships of the digital
object.

<a name="aip-premis-aip-included"></a>**AIP13**: If an AIP is
part of another AIP, then the element `relationshipSubType` MUST reference the
super-ordinate AIP.

An example of the latter case is shown in Listing 10.

```xml
<relationship>
    <relationshipType>structural</relationshipType>
    <relationshipSubType>is included in</relationshipSubType>
	<relatedObjectIdentification>
    	    <relatedObjectIdentifierType>repository</relatedObjectIdentifierType>
    	    <relatedObjectIdentifierValue>
               ID123e4567-e89b-12d3-a456-426655440000
        </relatedObjectIdentifierValue>
    </relatedObjectIdentification>
</relationship>
```

**Listing 10:**
Relationship

### PREMIS event

#### Event identifier

<a name="aip-premis-event-id"></a>**AIP15**: The `eventIdentifier`
SHOULD be used to identify events, such as preservation actions, which were applied.
An example is shown in Listing 12.

```xml
<eventIdentifier>
	<eventIdentifierType>local</eventIdentifierType>
	<eventIdentifierValue>PDF to PDF/A</eventIdentifierValue>
</eventIdentifier>
```

**Listing 12:**
Event identifier

#### Link to agent/object

<a name="aip-premis-event-agent"></a>**AIP16**: If an event is described, the agent which caused
the event (e.g. person, software, hardware, etc.) MUST be related to the event by means of the `linkingAgentIdentifier` element.

In the example shown in listing 20 the SIP to AIP conversion software is linked as agent with identifier value
’Sip2Aip’ and the corresponding object is linked by the local UUID value. An
example is shown in Listing 13.

```xml
<linkingAgentIdentifier>
    <linkingAgentIdentifierType>local</linkingAgentIdentifierType>
        <linkingAgentIdentifierValue>
            IngestSoftware
        </linkingAgentIdentifierValue>
    </linkingAgentIdentifier>
    <linkingObjectIdentifier>
    <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
        <linkingObjectIdentifierValue>
            metadata/file.xml
        </linkingObjectIdentifierValue>
</linkingObjectIdentifier>
```

**Listing 13:**
Link to agent/object

#### Migration event type

<a name="aip-premis-event-type"></a>**AIP17**: The event by which a
resource was created SHOULD to be recorded by means of the
`relatedEventIdentification` element.

An example is shown in Listing 14.

```xml
<event>
    <eventIdentifier>
        <eventIdentifierType>local</eventIdentifierType>
        <eventIdentifierValue>migration-001</eventIdentifierValue>
    </eventIdentifier>
    <eventType>MIGRATION</eventType>
    <eventDateTime>2015-09-01T01:00:00+01:00</eventDateTime>
    <eventOutcomeInformation>
        <eventOutcome>success</eventOutcome>
    </eventOutcomeInformation>
    <linkingAgentIdentifier>
        <linkingAgentIdentifierType>local</linkingAgentIdentifierType>
        <linkingAgentIdentifierValue>
            FileFormatConversion001
        </linkingAgentIdentifierValue>
    </linkingAgentIdentifier>
    <linkingObjectIdentifier>
        <linkingObjectIdentifierType>local</linkingObjectIdentifierType>
        <linkingObjectIdentifierValue>
            metadata/file.xml
        </linkingObjectIdentifierValue>
    </linkingObjectIdentifier>
    <relatedEventIdentification>
        <relatedEventIdentifierType>local</relatedEventIdentifierType>
        <relatedEventIdentifierValue>
            ingest-001
        </relatedEventIdentifierValue>
    </relatedEventIdentification>
</event>
```

**Listing 14:**
Migration event

The event shown in Listing 15 expresses the fact that the object
`metadata/file.xml` is the result of the migration event "migration-001" and the
event which created the source object is "ingest-001".

### PREMIS agent

<a name="aip-premis-agent"></a>**AIP18**: Agents which are referenced in
events must be described by means of the `agent` element.

Listing 15 shows a software for indexing named `IndexingSoftware` which supports
full text search of the items contained in a package.
In this case, the "discovery right" is assigned to this agent.

```xml
<agent>
    <agentIdentifier>
        <agentIdentifierType>local</agentIdentifierType>
        <agentIdentifierValue>Indexer</agentIdentifierValue>
    </agentIdentifier>
    <agentName>IndexingSoftware</agentName>
    <agentType>Software</agentType>
    <linkingRightsStatementIdentifier>
        <linkingRightsStatementIdentifierType>
            local
        </linkingRightsStatementIdentifierType>
        <linkingRightsStatementIdentifierValue>
            discovery-right-001
        </linkingRightsStatementIdentifierValue>
    </linkingRightsStatementIdentifier>
</agent>
```

**Listing 15:**
Software as an agent

## Physical Container Packaging

This part of the AIP format specification gives recommendations regarding the
creation of the physical packaging of the logical AIP into either one or
multiple transferable and storable entities.

### Naming of the AIP archive file

According to the requirement defined in section [5.3.1](#metsid)
("METS identifier"), every AIP bears an identifier which must be recorded
in the root METS file of the AIP. By definition, this identifier is the
identifier of the AIP itself.

<a name="aip-container-id"></a>**AIP20:**: The identifier of the AIP
-- defined by the attribute `OBJID` of the root METS file's root element SHOULD
be used to derive the beginning part of the file name of the physical storage
container.

The file name part which is derived from the AIP's identifier is called the
*AIP file name ID*.

<a name="aip-id-filename-mapping"></a>**AIP21**: A specified
policy SHOULD be defined which allows deriving a cross-platform, portable file
name part from the AIP's identifier and, vice versa, to infer the identifier
from the physical container's filename.

A first option to implement this requirement would be to limit the characters
used in the file name to the "Portable Filename Character Set"[^12] which
only allows the following character set for saving files:

[^12]: http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1\_chap03.html#tag\_03\_282

* Uppercase A to Z
* Lowercase a to z
* Numbers 0 to 9
* Period (.)
* Underscore (\_)
* Hyphen (-)

If the identifier of the AIP had characters which do not fall into this
character set, then these would need to be mapped into specific ones of the
accepted character set.

One proposed way to achieve a bi-directional mapping between identifiers and file names
is the pairtree character mapping specification.[^13]

[^13]: https://tools.ietf.org/html/draft-kunze-pairtree-01 (see section 3: “Identifier string cleaning”)

<a name="aip-container-suffix"></a>**AIP22**: The file name of the
physical container file SHOULD start with a unique name of the AIP which is equal for to
all versions and parts that belong to the same logical AIP.

For example, let us assume the identifier of the AIP was:

    "urn:uuid:123e4567-e89b-12d3-a456-426655440000"

Then this identifier string would be converted to the folder name because
“: -> +” is defined as a single-character to single-character conversion:

    "urn+uuid+123e4567-e89b-12d3-a456-426655440000"

The packaged entity should also bear this name, e.g. packaged using TAR the
name would be:

    "urn+uuid+123e4567-e89b-12d3-a456-426655440000.tar"

In this example, the AIP's physical container file name only consists of the
AIP file name ID.

### Packaging

Recommended formats for packaging AIPs are TAR and ZIP which are both widely used archive formats.

For both formats there are software utilities that can be used to bundle up files into one file for being
able to transfer archival packages.

<a name="aip-package-singlefolder"></a>**AIP27**: The package
content MUST be contained in a single folder.

This means that if the packaged AIP is unpackaged, the content MUST be extracted into a single folder which
contains the individuals files and folders.

As an example, let's assume a TAR file with the following name:

    "urn+uuid+123e4567-e89b-12d3-a456-426655440000.tar"

If it is extracted, a folder `urn+uuid+123e4567-e89b-12d3-a456-426655440000`
with the actual AIP content is created.

<a name="aip-package-uncompressed"></a>**AIP28**: If TAR is
used as the packaging format, the content SHOULD be aggregated without using compression.

For example, to create a TAR archive without compression for the AIP folder
`"urn+uuid+123e4567-e89b-12d3-a456-426655440000"` using the `tar` utility:

    tar -cf "urn+uuid+123e4567-e89b-12d3-a456-426655440000.tar" "urn+uuid+123e4567-e89b-12d3-a456-426655440000"

#### OCFL

The Oxford Common File Layout (OCFL) specification[^22] allows describing the storage structure of an AIP's physical container files.

It is an optional extension which can be used in addition to the packaging and file naming recommendations.

The purpose of the OCFL recommendation is to:

- define standards and conventions for storing and exporting versioned AIPs (AIP life-cycle).
- enable storing or exporting large amounts of archival content in form of AIP container files to file system storage
- support advanced use cases, such as splitting large information packages and differential AIPs (including removal of content using differential packages).

Listing 18 gives an example of an AIP (version 0) using OCFL. It is based on the OCFL Draft 2021[^23]
and the BagIt standard file system layout  for storage and transfer as defined by RFC8493[^24].

```xml
urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760
|- 0=ocfl_object_1.0
|- inventory.json
|- inventory.json.sha512
|- v0
    |- content
    |- urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760
      |- bag-info.txt
      |- bagit.txt
      |- data
      |   |- metadata
      |   |   |- descriptive
      |   |   |   |- ead.xml
      |   |   |   |- metadata.json
      |   |   |- preservation
      |   |       |- premis.xml
      |   |- METS.xml
      |   |- representations
      |       |- 9799fdd1-57b5-48e3-ba53-2705cc874a00
      |       |- data
      |       |   |- example.pdf
      |       |- metadata
      |       |   |- preservation
      |       |       |- premis.xml
      |       |- METS.xml
      |- manifest-sha256.txt
      |- manifest-sha512.txt
      |- tagmanifest-sha256.txt
      |- tagmanifest-sha512.txt
```

**Listing 18:**
OCFL file listing of an AIP (unpackaged container file)

Note that the OCFL Object includes all versions – v0, v1, … - of the AIP and that one bagit container
or several bagit containers (segmentation!) are managed as one OCFL object (See in OCFL 5.4 BagIt in an OCFL Object[^25]).
This is especially relevant for non-redundant storing of AIPs (the concept of a "differential AIP") and for package segmentation.

Also note that the exmaple in Listing 19 is the "unpackaged" version where the bagit container itself is not packaged.

The packaged version

```xml
urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760
|- 0=ocfl_object_1.0
|- inventory.json
|- inventory.json.sha512
|- v0
    |- content
      |- urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760.tar
```

**Listing 19:**
OCFL file listing of an AIP (packaged container file)

Note that serialization has been removed from the BagIt specification after version 14 (from 2017, current version is 17) to narrow the scope of the specification.
In BagIt Version 14 Section serialization was still included which defined the following requirements:

- The top-level directory of a serialization MUST contain only one bag.
- The serialization SHOULD have the same name as the bag's base directory, but MUST have an extension added to identify the format.
- A bag MUST NOT be serialized from within its base directory, but from the parent of the base directory.  
- The deserialization of a bag MUST produce a single base directory bag.

The content of the OCFL object file `0=ocfl_object_1.0` in the listing is shown in Listing 20.

```xml
ocfl_object_1.0
```

**Listing 20:**
OCFL file listing of an AIP (packaged container file)

And an example for the content of the `inventory.json` is is shown in Listing 21.

```json
{
    "digestAlgorithm": "sha512",
    "fixity": {
        "md5": {
            "e5ad509db4ddb4cef0de4c1c19c7988b": [
                "00000/content/urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760.tar"
            ]
        },
        "sha256": {
            "68a5b60ddef62758389f6894a1e7df28c1d228a5d56d2eec3ce2f74e80c27910": [
                "00000/content/urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760.tar"
            ]
        }
    },
    "head": "v0",
    "id": "urn:uuid:1017cc9b-eaed-4064-947e-a07c752d3760",
    "manifest": {
        "24db03a2a7d9c7e2e7ea533e2ac84b7274f937eaff31e95f508cd9c5418a902adf5c18d2f67fa80aa25b7d72ce829951e79ea66210959c86aab33b5ef0c8b8bc": [
            "00000/content/urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760.tar"
        ]
    },
    "type": "https://ocfl.io/1.0/spec/#inventory",
    "versions": {
        "v0": {
            "created": "2021-03-27T18:49:22Z",
            "message": "Original SIP",
            "state": {
                "24db03a2a7d9c7e2e7ea533e2ac84b7274f937eaff31e95f508cd9c5418a902adf5c18d2f67fa80aa25b7d72ce829951e79ea66210959c86aab33b5ef0c8b8bc": [
                    "00000/content/urn+uuid+1017cc9b-eaed-4064-947e-a07c752d3760.tar"
                ]
            }
        }
    }
}
```

**Listing 21:**
OCFL file listing of an AIP (packaged container file)

At the time of finalizing this specification, the OCFL standard does not support the listing of packaged container files in the inventory file.
This would allow using the inventory to document the actual content of physical container files and may follow in a future version of the AIP specification.

[^22]: https://ocfl.io
[^23]: https://ocfl.io/draft/spec/
[^24]: https://datatracker.ietf.org/doc/html/draft-kunze-bagit-17
[^25]: https://ocfl.io/draft/spec/#example-bagit-in-ocfl

