#include "core.h"
#include <linux/platform_device.h>
#include <asm/system.h>
#include <asm/io.h>
#include <linux/version.h>
#include <linux/dvb/dmx.h>
#include <linux/proc_fs.h>
#if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,17)
#include <linux/stm/pio.h>
#else
#include <linux/stpio.h>
#endif

#include <pvr_config.h>

short paramDebug = 0;
int bbgain = -1;

static struct core *core[MAX_DVB_ADAPTERS];

static struct stv090x_config tt1600_stv090x_config = {
#if defined(FORTIS_HDBOX)
	.device			= STV0903,
	.demod_mode		= STV090x_DUAL/*STV090x_SINGLE*/,
#elif defined(UFS912) || defined(SPARK)
	.device			= STX7111,
	.demod_mode		= STV090x_DUAL,
#else
#warning  not supported architechture
#endif
	.clk_mode		= STV090x_CLK_EXT,

#if defined(FORTIS_HDBOX)
	.xtal			= 16000000/*8000000*/,
#elif defined(UFS912) || defined(SPARK)
	.xtal			= 30000000,
#else
#warning  not supported architechture
#endif
	.address		= 0x68,
	.ref_clk		= 16000000,

#if defined(FORTIS_HDBOX)
	.ts1_mode		= STV090x_TSMODE_DVBCI/*STV090x_TSMODE_SERIAL_CONTINUOUS*/,
	.ts2_mode		= STV090x_TSMODE_DVBCI/*STV090x_TSMODE_SERIAL_CONTINUOUS*/,
#elif defined(UFS912) || defined(SPARK)
	.ts1_mode		= STV090x_TSMODE_DVBCI,
	.ts2_mode		= STV090x_TSMODE_SERIAL_CONTINUOUS,
#else
#warning  not supported architechture
#endif
	.ts1_clk		= 0, /* diese regs werden in orig nicht gesetzt */
	.ts2_clk		= 0, /* diese regs werden in orig nicht gesetzt */

#if defined(FORTIS_HDBOX)
	.repeater_level		= STV090x_RPTLEVEL_16,
#elif defined(UFS912) || defined(SPARK)
	.repeater_level		= STV090x_RPTLEVEL_64,
#else
#warning  not supported architechture
#endif

    .tuner_bbgain = 10,
	.adc1_range	= STV090x_ADC_1Vpp,
	.adc2_range	= STV090x_ADC_2Vpp,

	.diseqc_envelope_mode = false,
     
	.tuner_init		= NULL,
	.tuner_set_mode		= NULL,
	.tuner_set_frequency	= NULL,
	.tuner_get_frequency	= NULL,
	.tuner_set_bandwidth	= NULL,
	.tuner_get_bandwidth	= NULL,
	.tuner_set_bbgain	= NULL,
	.tuner_get_bbgain	= NULL,
	.tuner_set_refclk	= NULL,
	.tuner_get_status	= NULL,
};

static struct stv6110x_config stv6110x_config = {
	.addr			= (0xc0 >> 1),
	.refclk			= 16000000,
};

static const struct ix7306_config bs2s7hz7306a_config = {
	.name		= "Sharp BS2S7HZ7306A",
	.addr		= (0xc0>>1),
	.step_size 	= IX7306_STEP_1000,
	.bb_lpf		= IX7306_LPF_12,
	.bb_gain	= IX7306_GAIN_2dB,
};

static struct dvb_frontend * frontend_init(struct core_config *cfg, int i)
{
	struct stv6110x_devctl *ctl;
	struct dvb_frontend *frontend = NULL;
	enum tuner_type	tunerType = SHARP7306;

	printk (KERN_INFO "%s >\n", __FUNCTION__);
	
#if  defined(UFS912) || defined(SPARK)
		frontend = stv090x_attach(&tt1600_stv090x_config, cfg->i2c_adap, STV090x_DEMODULATOR_0, STV090x_TUNER1);
#else
	if (i== 0)
		frontend = stv090x_attach(&tt1600_stv090x_config, cfg->i2c_adap, STV090x_DEMODULATOR_0, STV090x_TUNER1);
	else
/* Dagobert commented: is this correct? second tuner uses demod0 ??? */
		frontend = stv090x_attach(&tt1600_stv090x_config, cfg->i2c_adap, STV090x_DEMODULATOR_0, STV090x_TUNER2);
#endif	
	if (frontend) {
		printk("%s: attached\n", __FUNCTION__);
		
		switch (tunerType) {
		case SHARP7306:
			if(dvb_attach(ix7306_attach, frontend, &bs2s7hz7306a_config, cfg->i2c_adap))
			{
				printk("%s: IX7306 attached\n", __FUNCTION__);
				//tt1600_stv090x_config.xtal = 4000000;
				tt1600_stv090x_config.tuner_set_frequency	= ix7306_set_frequency;
				tt1600_stv090x_config.tuner_get_frequency	= ix7306_get_frequency;
				tt1600_stv090x_config.tuner_set_bandwidth	= ix7306_set_bandwidth;
				tt1600_stv090x_config.tuner_get_bandwidth	= ix7306_get_bandwidth;
				tt1600_stv090x_config.tuner_get_status 		= frontend->ops.tuner_ops.get_status;
			}else{
				printk (KERN_INFO "%s: error attaching IX7306\n", __FUNCTION__);
				goto error_out;
			}
			break;
		case STV6110X:
		default:
			ctl = dvb_attach(stv6110x_attach, frontend, &stv6110x_config, cfg->i2c_adap);
			if(ctl) {
				printk("%s: stv6110x attached\n", __FUNCTION__);
				tt1600_stv090x_config.tuner_init		= ctl->tuner_init;
				tt1600_stv090x_config.tuner_set_mode		= ctl->tuner_set_mode;
				tt1600_stv090x_config.tuner_set_frequency	= ctl->tuner_set_frequency;
				tt1600_stv090x_config.tuner_get_frequency	= ctl->tuner_get_frequency;
				tt1600_stv090x_config.tuner_set_bandwidth	= ctl->tuner_set_bandwidth;
				tt1600_stv090x_config.tuner_get_bandwidth	= ctl->tuner_get_bandwidth;
				tt1600_stv090x_config.tuner_set_bbgain 		= ctl->tuner_set_bbgain;
				tt1600_stv090x_config.tuner_get_bbgain 		= ctl->tuner_get_bbgain;
				tt1600_stv090x_config.tuner_set_refclk 		= ctl->tuner_set_refclk;
				tt1600_stv090x_config.tuner_get_status 		= ctl->tuner_get_status;
			} else {
				printk (KERN_INFO "%s: error attaching stv6110x\n", __FUNCTION__);
				goto error_out;
			}
		}
	} else {
		printk (KERN_INFO "%s: error attaching\n", __FUNCTION__);
		goto error_out;
	}

	return frontend;

error_out:
	printk("core: Frontend registration failed!\n");
	if (frontend) 
		dvb_frontend_detach(frontend);
	return NULL;
}

static struct dvb_frontend *
init_stv090x_device (struct dvb_adapter *adapter,
                     struct plat_tuner_config *tuner_cfg, int i)
{
  struct dvb_frontend *frontend;
  struct core_config *cfg;

  printk ("> (bus = %d) %s\n", tuner_cfg->i2c_bus,__FUNCTION__);

  cfg = kmalloc (sizeof (struct core_config), GFP_KERNEL);
  if (cfg == NULL)
  {
    printk ("stv090x: kmalloc failed\n");
    return NULL;
  }

  /* initialize the config data */
  cfg->i2c_adap = i2c_get_adapter (tuner_cfg->i2c_bus);

  printk("i2c adapter = 0x%0x\n", (unsigned int)cfg->i2c_adap);

  cfg->i2c_addr = tuner_cfg->i2c_addr;

  printk("i2c addr = %02x\n", cfg->i2c_addr);

  printk("tuner enable = %d.%d\n", tuner_cfg->tuner_enable[0], tuner_cfg->tuner_enable[1]);


  frontend = frontend_init(cfg, i);

  if (frontend == NULL)
  {
    return NULL;
  }

  printk (KERN_INFO "%s: Call dvb_register_frontend (adapter = 0x%x)\n",
           __FUNCTION__, (unsigned int) adapter);

  if (dvb_register_frontend (adapter, frontend))
  {
    printk ("%s: Frontend registration failed !\n", __FUNCTION__);
    if (frontend->ops.release)
      frontend->ops.release (frontend);
    return NULL;
  }

  return frontend;
}

struct plat_tuner_config tuner_resources[] = {
        [0] = {
                .adapter = 0,
                .i2c_bus = 3,
                .i2c_addr = 0x68,
        },
};


void stv090x_register_frontend(struct dvb_adapter *dvb_adap)
{
	int i = 0;
	int vLoop = 0;

	printk (KERN_INFO "%s: stv090x DVB: 0.11 \n", __FUNCTION__);

	core[i] = (struct core*) kmalloc(sizeof(struct core),GFP_KERNEL);
	if (!core[i])
		return;

	memset(core[i], 0, sizeof(struct core));

	core[i]->dvb_adapter = dvb_adap;
	dvb_adap->priv = core[i];

	printk("tuner = %d\n", ARRAY_SIZE(tuner_resources));
	
	for (vLoop = 0; vLoop < ARRAY_SIZE(tuner_resources); vLoop++)
	{
	  if (core[i]->frontend[vLoop] == NULL)
	  {
      	     printk("%s: init tuner %d\n", __FUNCTION__, vLoop);
	     core[i]->frontend[vLoop] = 
				   init_stv090x_device (core[i]->dvb_adapter, &tuner_resources[vLoop], vLoop);
	  }
	}

	printk (KERN_INFO "%s: <\n", __FUNCTION__);

	return;
}

EXPORT_SYMBOL(stv090x_register_frontend);

int __init stv090x_init(void)
{
    printk("stv090x loaded\n");
    return 0;
}

static void __exit stv090x_exit(void) 
{  
   printk("stv090x unloaded\n");
}

module_init             (stv090x_init);
module_exit             (stv090x_exit);

module_param(paramDebug, short, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
MODULE_PARM_DESC(paramDebug, "Debug Output 0=disabled >0=enabled(debuglevel)");

module_param(bbgain, int, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP);
MODULE_PARM_DESC(bbgain, "default=-1 (use default config = 10");

MODULE_DESCRIPTION      ("Tunerdriver");
MODULE_AUTHOR           ("Manu Abraham; adapted by TDT");
MODULE_LICENSE          ("GPL");
