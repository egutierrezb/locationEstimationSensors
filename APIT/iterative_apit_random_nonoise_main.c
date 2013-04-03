/*
 * MATLAB Compiler: 4.0 (R14)
 * Date: Tue Jun 26 22:29:27 2007
 * Arguments: "-B" "macro_default" "-m" "-W" "main" "-T" "link:exe" "-v"
 * "Iterative_APIT_random_nonoise.m" "APIT_randomnonoise_repexp.m"
 * "deploy_nodes_random.m" "connectivity_ANR.m" "empmodel.m"
 * "drawtriangles_fst_def.m" "APITAggregation_fst_prueba.m" "COG.m"
 * "drawlinesrealestpos.m" "RMSE.m" 
 */

#include <stdio.h>
#include "mclmcr.h"
#ifdef __cplusplus
extern "C" {
#endif
extern const unsigned char __MCC_Iterative_APIT_random_nonoise_public_data[];
extern const char *__MCC_Iterative_APIT_random_nonoise_name_data;
extern const char *__MCC_Iterative_APIT_random_nonoise_root_data;
extern const unsigned char __MCC_Iterative_APIT_random_nonoise_session_data[];
extern const char *__MCC_Iterative_APIT_random_nonoise_matlabpath_data[];
extern const int __MCC_Iterative_APIT_random_nonoise_matlabpath_data_count;
extern const char *__MCC_Iterative_APIT_random_nonoise_mcr_runtime_options[];
extern const int __MCC_Iterative_APIT_random_nonoise_mcr_runtime_option_count;
extern const char *__MCC_Iterative_APIT_random_nonoise_mcr_application_options[];
extern const int __MCC_Iterative_APIT_random_nonoise_mcr_application_option_count;
#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;


static int mclDefaultPrintHandler(const char *s)
{
    return fwrite(s, sizeof(char), strlen(s), stdout);
}

static int mclDefaultErrorHandler(const char *s)
{
    int written = 0, len = 0;
    len = strlen(s);
    written = fwrite(s, sizeof(char), len, stderr);
    if (len > 0 && s[ len-1 ] != '\n')
        written += fwrite("\n", sizeof(char), 1, stderr);
    return written;
}

bool Iterative_APIT_random_nonoiseInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
    if (_mcr_inst != NULL)
        return true;
    if (!mclmcrInitialize())
        return false;
    if (!mclInitializeComponentInstance(&_mcr_inst,
                                        __MCC_Iterative_APIT_random_nonoise_public_data,
                                        __MCC_Iterative_APIT_random_nonoise_name_data,
                                        __MCC_Iterative_APIT_random_nonoise_root_data,
                                        __MCC_Iterative_APIT_random_nonoise_session_data,
                                        __MCC_Iterative_APIT_random_nonoise_matlabpath_data,
                                        __MCC_Iterative_APIT_random_nonoise_matlabpath_data_count,
                                        __MCC_Iterative_APIT_random_nonoise_mcr_runtime_options,
                                        __MCC_Iterative_APIT_random_nonoise_mcr_runtime_option_count,
                                        true, NoObjectType, ExeTarget, NULL,
                                        error_handler, print_handler))
        return false;
    return true;
}

bool Iterative_APIT_random_nonoiseInitialize(void)
{
    return Iterative_APIT_random_nonoiseInitializeWithHandlers(mclDefaultErrorHandler,
                                                               mclDefaultPrintHandler);
}

void Iterative_APIT_random_nonoiseTerminate(void)
{
    if (_mcr_inst != NULL)
        mclTerminateInstance(&_mcr_inst);
}

int main(int argc, const char **argv)
{
    int _retval;
    if (!mclInitializeApplication(__MCC_Iterative_APIT_random_nonoise_mcr_application_options,
                                  __MCC_Iterative_APIT_random_nonoise_mcr_application_option_count))
        return 0;
    
    if (!Iterative_APIT_random_nonoiseInitialize())
        return -1;
    _retval = mclMain(_mcr_inst, argc, argv,
                      "iterative_apit_random_nonoise", 9);
    if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
    Iterative_APIT_random_nonoiseTerminate();
    mclTerminateApplication();
    return _retval;
}
