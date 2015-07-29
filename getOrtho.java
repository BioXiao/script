import sbc.orthoxml.io.*;
import sbc.orthoxml.*;
import java.io.File;

class getOrtho
{
    public static void main(String[] argv) throws Exception
    {
	//open the orthoXML for reading
	OrthoXMLReader reader = new OrthoXMLReader(new File(argv[0]));
	
	//read the group iteratively
	Group group;
	while( (group = reader.next()) != null)
	    {
		//print group identifier and members
		System.out.println("#" + group.getId());
		for(Gene gene : group.getNestedGenes())
		    {
			System.out.println(gene.getGeneIdentifier());
			System.out.println(gene.getSpecies().getName());
		    }
		
	    }
    }
}
