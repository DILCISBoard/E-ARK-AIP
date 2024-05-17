# Scope and purpose

To briefly recall the three types of information packages as defined by OAIS
[@OAIS2012], there is the Submission Information Package (SIP) which is used to
submit digital objects to a repository system; the Archival Information Package
(AIP) which allows the transmission of a package to the repository, and its
storage over the long-term; and the Dissemination Information Package (DIP)
which is used to disseminate digital objects to the requesting user.

This document is specification of the E-ARK Archival Information Package format
(E-ARK AIP, subsequently referred to as AIP). It defines requirements and
guidelines for creating AIPs which are adequate to store information packages
for the long term. The key objectives of this format are to:

- define the AIP format as an extension of the E-ARK CSIP so that it is suitable for
  the long-term storage of a wide variety of data types, such as document and image
  collections, archival records, databases or geographical data.
- recommend specific ways of using metadata standards to improve interoperability
  with regard to the use of long-term archiving standards.
- specify a form of packaging AIP container files while ensuring that the
  format is suitable for the storage of large quantities of data.

# Relation to other documents

This specification document originates from the document "D4.4 Final version of
SIP-AIP conversion component (Part A: AIP specification)" [@e-ark-d4.4] created
in the E-ARK project (European Archival Records and Knowledge Preservation)
which ran from 2014 to 2017 and was funded by the European Commission as part of
the Seventh Framework Programme for Research.

The common requirements for all types of E-ARK information packages are defined
by the “Common Specification for Information Packages (CSIP) [see
@csip-2.0.0-DRAFT]”.

Further documents which are related to the AIP specification in a general sense
are listed in the CSIP (section 1.4 "Relation to other documents").

# Introduction

The AIP format defines an information package for storing archival content that
is going to be transferred to a repository for long-term preservation purposes.
The AIP format allows keeping a record of changes that are applied to an AIP in
form of metadata edits, digital preservation measures (e.g. migration or adding
emulation information), or submission updates.[^1]

[^1]: A *submission update* is a re-submission of an SIP at a later point in time
      related to an AIP which contains a previous version of this SIP.
      Section [5.2.1](#aipcontsubm) explains this concept more in detail.

The purpose of defining a standard format for the archival information package
is to pave the way for simplified repository migration. Given the increasing
amount of digital content archives need to safeguard nowadays, changing the
repository solution should be based on a standard exchange format. This is to
say that a data repository solution provider does not necessarily have to
implement this format as the internal storage format, but it should at least
allow exporting AIPs. By this way, the costly procedure of exporting data,
producing SIPs, and ingesting them again in the new repository can be
simplified. Data repository solution providers know what kind of existing data
they can expect if they were chosen to replace an existing repository solution.
An E-ARK conformant digital archive/archival solution shall be able to immediately 
analyse and incorporate existing data in form of AIPs without the need of applying 
data transformation or having to fulfil varying SIP creation requirements.

# Definitions and remarks

## Version and generation of an AIP

Information packages are permanent: more precisely the information they contain
is assumed to be permanent and always describes the same unaltered conceptual
entity. Nevertheless, the way in which this information is represented may change.

For the purposes of the AIP format specification, the concept *AIP version* is
used as defined by OAIS:

> “AIP Version: An AIP whose Content Information or Preservation Description
> Information has undergone a Transformation on a source AIP and is a candidate
> to replace the source AIP. An AIP version is considered to be the result of a
> Digital Migration. [@OAIS2012, p. 1-9]”

A new version of an AIP can contain one or more new representations which can be
either the result of a digital migration or information that enables the creation
of an emulation environment to render a representation. Or representation could
be removed from the AIP. In both cases the result is the creation of a new version
of the AIP. Also changing metadata related to the logical AIP as a whole 
may lead to a new AIP version. The logical AIP represents the same intellectual 
entity in all these cases.

*Definition:* An *AIP version* is a new form of the logical AIP for which 
either the metadata of the logical AIP or the representation information was changed, 
i.e. one or more representations have been modified or removed or were added.

If the logical AIP is changed, the physical representation of the information
in a container may change as well. 

*Definition:* A *generation* is a manifestation of a logical AIP in form of
one ore several physical container files.

# AIP format

The AIP format consists of a set of recommendations and requirements regarding the 
use of structural and preservation metadata which are introduced in the following.

## AIP specific structural metadata (METS)

<a name="mets"></a>

METS (Metadata Encoding and Transmission Standard) is a standard for encoding descriptive, 
administrative, and structural metadata formalised using the XML Schema Language. The use 
of METS in the AIP is mandatory and it must comply with the specification rules set by the 
CSIP. See CSIP for the general use of METS in information packages.

The E-ARK AIP specification may contain one or many representations. Additional representations 
may be added during the life-cycle of the AIP when preservation actions are applied. 

In the following  requirements concerning the METS for an E-ARK AIP will be specified. 

### Node level: mets root
