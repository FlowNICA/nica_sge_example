#include <fstream>
#include <sstream>
#include <string>

void macro(std::string infile, std::string outfile)
{
  std::cout << "Hello, world!" << std::endl;
  std::cout << "Input file: " << infile.c_str() << ", output file: " << outfile.c_str() << std::endl;

  TChain *chain = new TChain("mpdsim");

  std::ifstream instream(infile.c_str());
  std::string line;
  while (std::getline(instream, line))
  {
    chain->Add(line.c_str());
  }
  
  TFile *fOutput = new TFile(outfile.c_str(),"recreate");
  
  long nentries = (long)chain->GetEntries();
  
  for (long ievt=0; ievt<nentries; ievt++){
    // Do analysis for 1 event
  }
}
